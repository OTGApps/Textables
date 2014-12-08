module OpensourceCells
  def opensource_cells
    [{
      title: 'View on GitHub',
      image: 'github',
      action: :open_link,
      arguments: {
        url: 'https://github.com/MohawkApps/textables/',
        flurry_action: 'GITHUB_TAPPED'
      }
    }, {
      title: 'Found a bug?',
      subtitle: 'Log it here.',
      image: 'issue',
      action: :open_link,
      arguments: {
        url: 'https://github.com/MohawkApps/textables/issues/',
        flurry_action: 'GITHUB_ISSUE_TAPPED'
      }
    }, {
      title: 'Email me suggestions!',
      subtitle: 'I\'d love to hear from you',
      action: :email_me,
      image: 'email'
    }]
  end

  def open_link(args = {})
    Flurry.logEvent(args[:flurry_action]) unless Device.simulator?

    warn = {
      title: "Leaving #{App.name}",
      message: "This action will leave #{App.name} and open Safari.",
      buttons: ["Cancel", "OK"]
    }

    BW::UIAlertView.new({
      title: warn[:title],
      message: warn[:message],
      buttons: warn[:buttons],
      cancel_button_index: 0
    }) do |alert|
      App.open_url(args[:url]) unless alert.clicked_button.cancel?
    end.show
  end

  def email_me
    BW::Mail.compose({
      delegate: self,
      to: 'mark@mohawkapps.com',
      subject: "#{App.name} App Feedback",
      message: "",
      animated: true
    }) do |result, error|
      Flurry.logEvent("EMAIL_SENT") if result.sent? && !Device.simulator?
      Flurry.logEvent("EMAIL_CANCELED") if result.canceled? && !Device.simulator?
      Flurry.logEvent("EMAIL_FAILED") if result.failed? && !Device.simulator?
    end

  end
end
