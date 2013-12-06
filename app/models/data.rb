class Data

  def self.location
    use_default? ? resources : documents
  end

  def self.json_data
    BW::JSON.parse(File.read(location))
  end

  def self.use_default?
    !File.exist? documents
  end

  def self.resources
    File.join(App.resources_path, "content.json")
  end

  def self.documents
    File.join(App.documents_path, "content.json")
  end

end
