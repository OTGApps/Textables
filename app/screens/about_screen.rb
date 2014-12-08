class AboutScreen < PM::TableScreen
  include SettingsCells
  include ShareCells
  include OpensourceCells
  include AboutCells

  title 'About'

  def on_load
    set_nav_bar_button :right, title: "Close", action: :close, system_item: :stop
    Flurry.logEvent("VIEWED_ABOUT") unless Device.simulator?
  end

  def table_data
    [{
      title: "Settings:",
      cells: settings_cells
    }, {
      title: "Share With Your friends:",
      cells: share_cells
    }, {
      title: "#{App.name} is open source:",
      cells: opensource_cells
    }, {
      title: "About #{App.name}:",
      cells: about_cells
    }]
  end

  def close
    dismissModalViewControllerAnimated(true)
  end
end
