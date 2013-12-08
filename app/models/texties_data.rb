class TextiesData

  def self.location
    use_default? ? TextiesData.resources : TextiesData.documents
  end

  def self.json
    BW::JSON.parse(File.read(TextiesData.location))
  end

  def self.use_default?
    !File.exist? TextiesData.documents
  end

  def self.resources
    File.join(App.resources_path, "content.json")
  end

  def self.documents
    File.join(App.documents_path, "content.json")
  end

  def self.categories_count
    TextiesData.json.count
  end

  def self.texties_count
    count = 0
    TextiesData.json.each do |category|
      count = count + (category["items"].reject{|i| i['name'] == "" }.count || 0)
    end
    count
  end

end
