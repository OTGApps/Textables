describe "String Methods" do

  it "creates upsidedown text" do
    "abcdefghijklmnopqrstuvwxyz!?,.".upside_down.reverse.should == "ɐqɔpәɟƃɥᴉɾʞlɯuodbɹsʇnʌʍxʎz¡¿'˙"
  end

  it "creates kanjified text" do
    "abcdefghijklmnopqrstuvwxyz".kanjify.should == "ﾑ乃cd乇ｷgんﾉﾌズﾚM刀oｱq尺丂ｲu√wﾒﾘ乙"
  end

  it "should not translate characters not in the regexp hash" do
    "2".upside_down.should == "2"
    "2".kanjify.should == "2"
  end

end
