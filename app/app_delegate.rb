class AppDelegate

  attr_accessor :window, :view_controller

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    return true if RUBYMOTION_ENV == 'test'

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

    # Set the initial value to remind people. This must be turned off manually.
    App::Persistence['show_notifications'] = true if App::Persistence['show_notifications'].nil?

    self.view_controller = TextablesViewController.alloc.initWithCollectionViewLayout(UICollectionViewFlowLayout.new)
    nav_controller = UINavigationController.alloc.initWithRootViewController(self.view_controller)

    self.window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    self.window.rootViewController = nav_controller
    self.window.makeKeyAndVisible
    self.window.tintColor = "#00CC99".to_color

    Appirater.appLaunched(true) unless Device.simulator?

    true
  end

  def applicationDidBecomeActive(application)
    @messages = Takeoff::Messages.new
    @messages.schedule launch:1, title:"Welcome to #{App.name}!", message:"#{App.name} is a fun way to share unique text artwork with your friends!\n\nTap a Textie to get started!"
    @messages.schedule launch:5, title:"Quick Tip:", message:"If you favorite a Textie, it adds it to the top of this screen!"
    @messages.schedule launch:10, title:"Crazy Text".kanjify, message:"Tap the " << "crazy".kanjify << " button to create your own crazy text and send to friends!"
    @messages.schedule(
      launch: 30,
      title: "Have You Shared #{App.name} Yet?",
      message: "You've been using #{App.name} a lot!\n\nWant to share the app with some friends? We'd love you forever!",
      action: Proc.new{ App.delegate.view_controller.show_about },
      buttons: ["No Thanks", "OK"]
    )
    @messages.takeoff

    Takeoff::Reminders.reset
    Appirater.appEnteredForeground(true) unless Device.simulator?
  end

  def applicationDidEnterBackground(application)
    # Schedule a bunch of reminders to use the app.
    return if App::Persistence['show_notifications'] == false

    (1..3).to_a.each do |interval|
      message = "You haven't sent a Textie in #{interval} week"

      case interval
      when 1
        message << ". I bet your friends could use a laugh!"
      when 2
        message << "s. Try sending a Textie to a friend!"
      when 3
        message << "s. We'll stop bothering you. ¯\\_(ツ)_/¯"
      end

      Takeoff::Reminders.schedule(
        body: message,
        fire_date: interval.week
      )
    end
  end

  #Flurry exception handler
  def uncaughtExceptionHandler(exception)
    Flurry.logError("Uncaught", message:"Crash!", exception:exception)
  end

end
