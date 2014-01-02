describe "TextablesViewController" do
  tests TextablesViewController

  def controller
    rotate_device to: :portrait, button: :bottom
    App::Persistence['favorites'] = nil
    @vc = TextablesViewController.alloc.initWithCollectionViewLayout(UICollectionViewFlowLayout.new)
    @nav_controller = UINavigationController.alloc.initWithRootViewController(@vc)
  end

  after do
    @vc = nil
    @nav_controller = nil
  end

  it "sets the title to the app name" do
    @vc.title.should == App.name
  end

  it "sets nav items" do
    @vc.navigationItem.rightBarButtonItems.count.should == 1
    @vc.navigationItem.leftBarButtonItems.count.should == 1

    @vc.navigationItem.rightBarButtonItem.class.should == UIBarButtonItem
    @vc.navigationItem.leftBarButtonItem.class.should == UIBarButtonItem
  end

  it "should have che correct layout" do
    @vc.collectionView.collectionViewLayout.class.should == UICollectionViewFlowLayout
  end

  it "should have some sections" do
    @vc.collectionView.numberOfSections.should.be > 0
    @vc.collectionView.numberOfSections.should == @vc.data.count
  end

  it "should have some cells in the first section" do
    @vc.collectionView(@vc.collectionView, numberOfItemsInSection:0).should.be > 0
  end

  it "should add a favorite" do
    sections = @vc.collectionView.numberOfSections
    art = @vc.data[0]["items"][0]

    @vc.toggle_favorite(art)
    @vc.collectionView.numberOfSections.should == (sections + 1)
    @vc.collectionView(@vc.collectionView, numberOfItemsInSection:0).should == 1

    @vc.toggle_favorite(art)
    @vc.collectionView.numberOfSections.should == sections
  end

  it "should add multiple favorites" do
    sections = @vc.collectionView.numberOfSections
    art1 = @vc.data[0]["items"][0]
    art2 = @vc.data[1]["items"][2]

    @vc.toggle_favorite art1
    @vc.toggle_favorite art2

    @vc.collectionView.numberOfSections.should == (sections + 1)
    @vc.collectionView(@vc.collectionView, numberOfItemsInSection:0).should == 2
  end

  it "should star the favorited cell" do
    art = @vc.data[0]["items"][0]

    @vc.toggle_favorite(art)
    cell_path = NSIndexPath.indexPathForRow(0, inSection:0)
    cell = @vc.collectionView(@vc.collectionView, cellForItemAtIndexPath:cell_path)

    cell.favorite?.should == true
  end

end
