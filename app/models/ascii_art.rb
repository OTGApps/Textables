class ASCIIArt

  attr_accessor :art, :title

  def initialize options={}
    self.art = options[:art]
    self.title = options[:title]
  end

  def to_dict
    {
      art: self.art,
      title: self.title
    }
  end

end
