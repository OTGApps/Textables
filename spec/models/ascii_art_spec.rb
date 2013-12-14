describe "ASCIIArt" do

  it "has art and name" do
    a = ASCIIArt.new
    a.art.should == nil
    a.name.should == nil
  end

  it "sets art and name" do
    a = ASCIIArt.new(art: "Art", name: "Name")
    a.art.should == "Art"
    a.name.should == "Name"
  end

  it "converts to a dictionary" do
    a = ASCIIArt.new(art: "Art", name: "Name")
    a.to_dict.class.should == Hash
    a.to_dict.should == {art: "Art", name: "Name"}
  end

end
