class AboutViewController < Formotion::FormController

  def viewDidLoad
    super

    self.title = "About"
    self.navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemStop, target:self, action:"dismissModalViewControllerAnimated:")
  end

end
