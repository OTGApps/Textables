class Favorites

  def self.count
    Favorites.all.count
  end

  def self.all
    App::Persistence['favorites'] || []
  end

  def self.toggle art
    mp "Toggling: #{art}"
    if Favorites.is_favorite? art
      Favorites.unfavorite art
    else
      Favorites.favorite art
    end
  end

  def self.is_favorite? art
    mp "Is favorite? #{art} - #{Favorites.all.include? art}"
    Favorites.all.include? art
  end

  def self.favorite art
    mp "Setting favorite: #{art}"
    Flurry.logEvent("FAVORITE", withParameters:{art: art["art"]}) unless Device.simulator?
    favs = Favorites.all.mutableCopy
    favs << art
    App::Persistence['favorites'] = favs
  end

  def self.unfavorite art
    mp "Removing favorite: #{art}"
    favs = Favorites.all.mutableCopy
    Flurry.logEvent("UNFAVORITE", withParameters:{art: art["art"]}) unless Device.simulator?
    favs.reject!{|ascii| ascii["art"] == art[:art] && ascii["name"] == art[:name]}
    App::Persistence['favorites'] = favs
  end

end
