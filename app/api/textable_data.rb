class TextableData

  API_URL = "https://raw.githubusercontent.com/MohawkApps/Textables/master/resources/content.json"

  def self.shared
    Dispatch.once { @instance ||= new }
    @instance
  end

  def self.excluded_services
    [
      :add_to_reading_list,
      :air_drop,
      :print
    ]
  end

  def file_name
    'content.json'
  end

  def downloaded_exists?
    file_name.document_path.file_exists?
  end

  def download_age
    downloaded_exists? ? File.stat(file_name.document_path).mtime.to_i : 0
  end

  def should_download_data?
    if (App::Persistence['motion_takeoff_launch_count'].nil? || App::Persistence['motion_takeoff_launch_count'] < 2) && !Device.simulator?
      false
    else
      ((Device.simulator?) ? 20.seconds.ago.to_i : 1.days.ago.to_i) > download_age
    end
  end

  def download_data
    return if !should_download_data?

    # mp file_name.document_path

    # mp "Trying to download data from github."
    AFMotion::HTTP.get(API_URL, q: Time.now.to_i) do |result|
      if result.success?
        # mp 'Got data from github.'
        old_count = textables_count
        # mp "Old textables: #{old_count}"

        # Save it to the filesystem
        file_name.document_path.remove_file! if downloaded_exists?
        result.object.write_to(file_name.document_path)

        App::Persistence['last_checked_texties'] = Time.now.to_i
        cleanup

        new_count = textables_count
        # mp "New count: #{new_count}"

        Flurry.logEvent("API_HIT", withParameters:{old_count: old_count, new_count: new_count}) unless Device.simulator?

        if new_count > old_count
          NSLog "Got #{new_count - old_count} new texties."
          App.alert("New #{App.name} added:", message: "We just added #{new_count - old_count} new #{App.name}!\nEnjoy!")
        elsif old_count > new_count
          # We want to use the one on disk.
          file_name.document_path.remove_file! if downloaded_exists?
          cleanup
        end

        App.notification_center.post 'ReloadTextablesNotification'
      else
        NSLog("Error: Can not retrieve textables from github.")
        Flurry.logEvent("API_ERROR") unless Device.simulator?
      end
    end
  end

  def hash
    @_hash ||= begin
      if downloaded_exists?
        BW::JSON.parse(File.read(file_name.document_path))
      else
        BW::JSON.parse(File.read(file_name.resource_path))
      end
    end
  end

  def categories_count
    @_categories_count ||= hash.count
  end

  def textables_count
    @_textables_count ||= begin
      c = 0
      hash.each do |category|
        c = c + (category["items"].reject{|i| i['name'] == "" }.count || 0)
      end
      c
    end
  end

  def cleanup
    @_categories_count = nil
    @_textables_count = nil
    @_hash = nil
  end

end
