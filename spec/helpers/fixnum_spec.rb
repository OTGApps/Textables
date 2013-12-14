describe "Fixnum Methods" do

  it "should return a time in the past" do
    ago = 1.ago
    ago.class.should == Time
    ago.to_i.should < Time.now.to_i
  end

  it "should convert mintues to seconds" do
    2.minutes.should == 120
    5000.minutes.should == 300000
  end

  it "should convert hours to seconds" do
    5.hours.should == 18000
    2754.hours.should == 9914400
  end

  it "should convert days to seconds" do
    7.days.should == 604800
    12.days.should == 1036800
  end

  it "should convert weeks to seconds" do
    2.weeks.should == 1209600
    15.weeks.should == 9072000
  end

end
