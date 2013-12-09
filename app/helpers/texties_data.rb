class TextiesData

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

  def texties_count
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
