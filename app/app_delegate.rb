class AppDelegate < PM::Delegate
  status_bar true, animation: :none

  def on_load(app, options)
    create_random_contacts if Device.simulator?
    nav_controller = UINavigationController.alloc.initWithRootViewController(PackageViewController.alloc.initWithCollectionViewLayout(UICollectionViewFlowLayout.new))
    open nav_controller
  end

  def create_random_contacts
    ab = AddressBook::AddrBook.new
    if ab.people.count == 0
       # create 200 random contacts
      [*0..200].each do |i|
        ab.create_person(:first_name => "Name #{i}", :last_name => "Last #{i}", :emails => [{ :value => "#{i}@#{i}foo.com", :label => 'Home'}], :phones => [{ :value => '9920149993', :label => 'Mobile'}])
      end
    end
  end

end
