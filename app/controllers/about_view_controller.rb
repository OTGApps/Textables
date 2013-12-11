class AboutViewController < Formotion::FormController

  def init
    north_carolina_coords = CLLocationCoordinate2D.new(35.244140625, -79.8046875)
    north_carolina = CLCircularRegion.alloc.initWithCenter(north_carolina_coords, radius:225093, identifier:"North Carolina")
    charlotte = CLLocationCoordinate2D.new(35.2269444, -80.8433333)

    form = Formotion::Form.new({
      sections: [{
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
          value: "https://github.com/MohawkApps/Texties"
        }, {
          title: "Found a bug?",
          subtitle: "Log it here.",
          type: :issue_link,
          image: "issue",
          value: "https://github.com/MohawkApps/Texties/issues/"
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
          value: "http://www.mohawkapps.com"
        }, {
          title: "Made in North Carolina",
          type: :static,
          enabled: false,
          selection_style: :none,
          text_alignment: NSTextAlignmentCenter
        },{
          type: :static_image,
          value: "nc",
          # row_height: 40
        }]
      }]
    })
    super.initWithForm(form)
  end

  def viewDidLoad
    super
    self.title = "About"
    self.navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemStop, target:self, action:"close")
  end

  def close
    dismissModalViewControllerAnimated(true)
  end

end
