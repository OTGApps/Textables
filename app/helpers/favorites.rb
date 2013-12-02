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
    if Favorites.is_favorite? art
      Favorites.unfavorite art
    else
      Favorites.favorite art
    end
  end

  def self.is_favorite? art
    Favorites.all.include? art
  end

  def self.favorite art
    favs = Favorites.all.mutableCopy
    favs << art.to_dict
    App::Persistence['favorites'] = favs.uniq
  end

  def self.unfavorite art
    favs = Favorites.all_raw.mutableCopy
    favs -= [art.to_dict]
    App::Persistence['favorites'] = favs
  end

end
