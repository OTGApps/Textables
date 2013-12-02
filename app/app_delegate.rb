class AppDelegate < PM::Delegate
  status_bar true, animation: :none

  def on_load(app, options)
    nav_controller = UINavigationController.alloc.initWithRootViewController(PackageViewController.alloc.initWithCollectionViewLayout(UICollectionViewFlowLayout.new))
    open nav_controller
  end

end
