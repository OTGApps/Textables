class TextablesData

  def self.excluded_services
    [
      UIActivityTypeAddToReadingList,
      UIActivityTypeAirDrop,
      UIActivityTypeCopyToPasteboard,
      UIActivityTypePrint
    ]
  end

  def self.needs_textification?
    # Don't check the server if the launch count is under 2
    return false if App::Persistence['motion_takeoff_launch_count'] < 2 && !Device.simulator?

    time = (Device.simulator?) ? 20.seconds.ago.to_i : 2.days.ago.to_i
    App::Persistence['last_checked_texties'].nil? || time > App::Persistence['last_checked_texties']
  end

  # def self.excluded_services
  #   [:add_to_reading_list, :air_drop, :copy_to_pasteboard,:print]
  # end

  def self.sharedData
    Dispatch.once { @instance ||= new }
    @instance
  end

  def location
    use_default? ? resources : documents
  end

  def json
    @j_data ||= BW::JSON.parse(File.read(location))
  end

  def use_default?
    !File.exist? documents
  end

  def resources
    @r_path ||= File.join(App.resources_path, "content.json")
  end

  def documents
    @d_path ||= File.join(App.documents_path, "content.json")
  end

  def categories_count
    @j_count ||= json.count
  end

  def textables_count
    @count ||= begin
      c = 0
      json.each do |category|
        c = c + (category["items"].reject{|i| i['name'] == "" }.count || 0)
      end
      c
    end
  end

  def cleanup
    @count = nil
    @j_count = nil
    @j_data = nil
  end

end
