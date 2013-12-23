class AboutViewController < Formotion::FormController
  include BW::KVO

  def init
    @form ||= Formotion::Form.new({
      sections: [{
        title: "Settings:",
        rows: [{
          title: "Remind me to use #{App.name}",
          type: :switch,
          value: App::Persistence['show_notifications']
        }]
      },{
        title: "Tell Your friends:",
        rows: [{
          title: "Share the app",
          subtitle: "Text, Email, Tweet, or Facebook!",
          type: :share,
          image: "share",
          value: {
            items: "I'm using the #{App.name} app to send cool text art. Check it out! http://www.textiesapp.com/",
            excluded: TextieUtils.excluded_services
          }
        },{
          title: "Rate #{App.name} on iTunes",
          type: :rate_itunes,
          image: "itunes"
        }]
      }, {
        title: "#{App.name} is open source:",
        rows: [{
          title: "View on GitHub",
          type: :github_link,
          image: "github",
          value: {
            warn: true,
            url: "https://github.com/MohawkApps/Texties"
          }
        }, {
          title: "Found a bug?",
          subtitle: "Log it here.",
          type: :issue_link,
          image: "issue",
          value: {
            warn: true,
            url: "https://github.com/MohawkApps/Texties/issues/"
          }
        }, {
          title: "Email me suggestions!",
          subtitle: "I'd love to hear from you",
          type: :email_me,
          image: "email",
          value: {
            to: "mark@mohawkapps.com",
            subject: "Texties App Feedback"
          }
        }]
      }, {
        title: "About Texties:",
        rows: [{
          title: "Version",
          type: :static,
          placeholder: App.info_plist['CFBundleShortVersionString'],
          selection_style: :none
        }, {
          title: "Copyright",
          type: :static,
          font: { name: 'HelveticaNeue', size: 14 },
          placeholder: "© 2013, Mohawk Apps, LLC",
          selection_style: :none
        }, {
          title: "Visit MohawkApps.com",
          type: :web_link,
          value: {
            warn:true,
            url: "http://www.mohawkapps.com"
          }
        }, {
          title: "Made with ♥ in North Carolina",
          type: :static,
          enabled: false,
          selection_style: :none,
          text_alignment: NSTextAlignmentCenter
        },{
          type: :static_image,
          value: "nc",
          enabled: false,
          selection_style: :none
        }]
      }]
    })
    super.initWithForm(@form)
  end

  def viewDidLoad
    super
    self.title = "About"
    self.navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemStop, target:self, action:"close")
    observe_switch
  end

  def close
    dismissModalViewControllerAnimated(true)
  end

  def observe_switch
    row = @form.sections[0].rows[0]
    observe(row, "value") do |old_value, new_value|
      App::Persistence['show_notifications'] = new_value
    end
  end

end
