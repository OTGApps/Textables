describe "SectionHeader" do

  before do
    @header = SectionHeader.alloc.initWithFrame(CGRectZero)
  end

  after do
    @header = nil
  end

  it "should be a collection view header" do
    @header.superclass.should.be == UICollectionReusableView
  end

  it "should have one label" do
    @header.subviews.count.should == 1
  end

  it "should set the label text" do
    @header.display_string = "Testing"
    @header.display_label.text.should == "Testing"
  end

end
