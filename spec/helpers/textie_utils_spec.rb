describe "TextablesUtils" do

  it "should return an array of excluded services" do
    excluded = TextablesUtils.excluded_services
    excluded.class.should == Array
    excluded.count.should.be > 0
  end

end
