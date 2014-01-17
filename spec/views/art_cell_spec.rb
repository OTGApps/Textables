describe "ArtCell" do
  # tests ArtCell

  before do
    @cell = ArtCell.alloc.initWithFrame(CGRectMake(0, 0, 145, 75))
  end

  after do
    @cell = nil
  end

  it "should be a collection view cell" do
    @cell.superclass.should.be == UICollectionViewCell
  end

  it "should have two text fields" do
    @cell.title_label.class.should == UILabel
    @cell.art_label.class.should == UILabel
  end

  it "should set the art label" do
    @cell.art = {art:"Art", name:"Title"}
    @cell.art_label.text.should == "Art"
  end

  it "should set the title label" do
    @cell.art = {art:"Art", name:"Title"}
    @cell.title_label.text.should == "Title"
  end

  it "should return an art object when asked" do
    a = {art:"Art", name:"Title"}
    @cell.art = a
    @cell.art.should == a
  end

  it "should set a favorite" do
    @cell.favorite?.should == nil
    @cell.favorite = true
    @cell.favorite?.should == true
    @cell.favorite = false
    @cell.favorite?.should == false
  end

end
