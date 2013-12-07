class AppDelegate

  attr_accessor :window

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    # 3rd Party integrations
    unless Device.simulator?
      app_id = NSBundle.mainBundle.objectForInfoDictionaryKey('APP_STORE_ID')

      # Flurry
      NSSetUncaughtExceptionHandler("uncaughtExceptionHandler")
      Flurry.startSession("CX7X2RMSF8WR5KB53H7T")

      # Appirater
      Appirater.setAppId app_id

      # Harpy
      Harpy.sharedInstance.setAppID app_id
      Harpy.sharedInstance.checkVersion
    end

    texties_vc = TextiesViewController.alloc.initWithCollectionViewLayout(UICollectionViewFlowLayout.new)
    nav_controller = UINavigationController.alloc.initWithRootViewController(texties_vc)

    self.window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    self.window.rootViewController = nav_controller
    self.window.makeKeyAndVisible
    self.window.tintColor = "#00CC99".to_color

    Appirater.appLaunched(true) unless Device.simulator?

    true
  end

  def applicationDidBecomeActive(application)
    messages = MotionTakeoff::Messages.new
    messages.schedule launch:1, title:"Welcome to #{App.name}!", message:"#{App.name} is a fun way to share unique text artwork with your friends!\n\nTap a Textie to get started!"
    messages.schedule launch:3, title:"Quick Tip:", message:"If you favorite a Textie, it adds it to the top of this screen!"
    messages.schedule launch:5, title:"Crazy Text".kanjify, message:"Tap the " << "crazy".kanjify << " button to create your own crazy text and send to friends!"
    messages.takeoff

    MotionTakeoff::Reminders.reset
    Appirater.appEnteredForeground(true) unless Device.simulator?
  end

  def applicationDidEnterBackground(application)
    # Schedule a bunch of reminders to use the app.
    MotionTakeoff::Reminders.schedule(
      body: "You haven't sent a Textie in a week. I bet your friends could use a laugh!",
      fire_date: 1.week
    )

    MotionTakeoff::Reminders.schedule(
      body: "You haven't used #{App.name} in 2 weeks! Try sending a Textie to a friend!",
      fire_date: 2.weeks
    )

    MotionTakeoff::Reminders.schedule(
      body: "You haven't used #{App.name} in 3 weeks. We'll stop bothering you. ¯\\_(ツ)_/¯",
      fire_date: 3.weeks
    )

  end

  #Flurry exception handler
  def uncaughtExceptionHandler(exception)
    Flurry.logError("Uncaught", message:"Crash!", exception:exception)
  end

end
