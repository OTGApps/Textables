describe "TextablesData" do

  # TODO: Write tests

  it "should return an array of excluded services" do
    excluded = TextablesData.excluded_services
    excluded.class.should == Array
    excluded.count.should.be > 0
  end

end
