describe "Favorites" do

  before do
    App::Persistence['favorites'] = nil
    @art = {art: "Art", name: "Name"}
  end

  it "returns a count of favorites" do
    Favorites.count.should == 0
  end

  it "saves a favorite" do
    Favorites.favorite @art
    Favorites.count.should == 1
    Favorites.count.should == Favorites.all.count
  end

  it "removes a favorite" do
    Favorites.favorite @art
    Favorites.count.should == 1
    Favorites.unfavorite @art
    Favorites.count.should == 0
  end

  it "toggles a favorite" do
    Favorites.count.should == 0
    Favorites.toggle @art
    Favorites.count.should == 1
    Favorites.toggle @art
    Favorites.count.should == 0
  end

end
