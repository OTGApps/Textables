class ASCIIArt

  attr_accessor :art, :name

  def initialize options={}
    self.art = options[:art]
    self.name = options[:name]
  end

  def to_dict
    {
      art: self.art,
      name: self.name
    }
  end

end
