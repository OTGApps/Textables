class Favorites

  def self.count
    Favorites.all_raw.count
  end

  def self.all
    all = []
    return all unless App::Persistence['favorites']

    App::Persistence['favorites'].each do |fav|
      all << ASCIIArt.new(fav)
    end
    all
  end

  def self.all_raw
    App::Persistence['favorites'] || []
  end

  def self.toggle art
    # ap "Toggling: #{art}"
    if Favorites.is_favorite? art
      Favorites.unfavorite art
    else
      Favorites.favorite art
    end
  end

  def self.is_favorite? art
    # ap "Is favorite? #{art} - #{Favorites.all_raw.include? art.to_dict}"
    art = art.to_dict unless art.is_a? Hash
    Favorites.all_raw.include? art
  end

  def self.favorite art
    # ap "Setting favorite: #{art.art}"
    art = art.to_dict unless art.is_a? Hash
    Flurry.logEvent("FAVORITE", withParameters:{art: art["art"]})
    favs = Favorites.all_raw.mutableCopy
    favs << art
    App::Persistence['favorites'] = favs
  end

  def self.unfavorite art
    # ap "Removing favorite: #{art.to_dict}"
    favs = Favorites.all_raw.mutableCopy
    Flurry.logEvent("UNFAVORITE", withParameters:{art: art["art"]})
    art = art.to_dict unless art.is_a? Hash
    favs.reject!{|ascii| ascii["art"] == art[:art] && ascii["name"] == art[:name]}
    App::Persistence['favorites'] = favs
  end

end
