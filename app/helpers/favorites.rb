class Favorites

  def self.count
    Favorites.all.count
  end

  def self.all
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
    # ap "Is favorite? #{art} - #{Favorites.all.include? art.to_dict}"
    art = art.to_dict unless art.is_a? Hash
    Favorites.all.include? art
  end

  def self.favorite art
    # ap "Setting favorite: #{art.art}"
    art = art.to_dict unless art.is_a? Hash
    Flurry.logEvent("FAVORITE", withParameters:{art: art["art"]}) unless Device.simulator?
    favs = Favorites.all.mutableCopy
    favs << art
    App::Persistence['favorites'] = favs
  end

  def self.unfavorite art
    # ap "Removing favorite: #{art.to_dict}"
    favs = Favorites.all.mutableCopy
    Flurry.logEvent("UNFAVORITE", withParameters:{art: art["art"]}) unless Device.simulator?
    art = art.to_dict unless art.is_a? Hash
    favs.reject!{|ascii| ascii["art"] == art[:art] && ascii["name"] == art[:name]}
    App::Persistence['favorites'] = favs
  end

end
