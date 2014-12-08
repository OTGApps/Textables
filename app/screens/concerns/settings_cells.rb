module SettingsCells
  def settings_cells
    [{
      title: "Remind me to use #{App.name}",
      accessory: {
        view: :switch,
        action: :switched,
        value: App::Persistence['show_notifications'],
        arguments: { persistence: 'show_notifications' }
      }
    }]
  end

  def switched(args = {})
    App::Persistence[args[:persistence]] = args[:value] || false

    # Log the change in Flurry
    flurry_params = {on_off: args[:value]}
    Flurry.logEvent("#{args[:persistence].upcase}_SWITCH", withParameters:flurry_params) unless Device.simulator?
  end
end
