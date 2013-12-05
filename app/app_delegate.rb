class AppDelegate

  attr_accessor :window

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    nav_controller = UINavigationController.alloc.initWithRootViewController(PackageViewController.alloc.initWithCollectionViewLayout(UICollectionViewFlowLayout.new))
    self.window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    self.window.rootViewController = nav_controller
    self.window.makeKeyAndVisible
    self.window.tintColor = "#00CC99".to_color
    return true
  end

end
