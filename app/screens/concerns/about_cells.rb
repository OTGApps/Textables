module AboutCells
  def about_cells
    [{
      title: 'Version:',
      subtitle: App.info_plist['CFBundleShortVersionString'],
    }, {
      title: 'Copyright:',
      subtitle: '© 2014, Mohawk Apps, LLC',
    }, {
      title: 'Visit MohawkApps.com',
      action: :open_link,
      arguments: {
        url: 'http://www.mohawkapps.com',
        flurry_action: 'WEBLINK_TAPPED'
      }
    }]
  end
end
