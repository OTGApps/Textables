class AppDelegate

  attr_accessor :window

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    texties_vc = TextiesViewController.alloc.initWithCollectionViewLayout(UICollectionViewFlowLayout.new)
    nav_controller = UINavigationController.alloc.initWithRootViewController(texties_vc)

    self.window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    self.window.rootViewController = nav_controller
    self.window.makeKeyAndVisible
    self.window.tintColor = "#00CC99".to_color
    true
  end

  def applicationDidBecomeActive(application)
    messages = MotionTakeoff::Messages.new
    messages.message launch:1, title:"Welcome to #{App.name}!", message:"#{App.name} is a fun way to share unique text artwork with your friends!\n\nTap a Textie to get started!"
    messages.message launch:3, title:"Quick Tip:", message:"If you favorite a Textie, it adds it to the top of this screen!"
    messages.message launch:5, title:"C尺ﾑ乙ﾘ ｲ乇ﾒｲ!", message:"Tap the c尺ﾑ乙ﾘ button to create your own crazy text and send to friends!"
    messages.takeoff
  end

end
