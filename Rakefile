# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'
require "rubygems"
require 'bundler'
Bundler.require

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'Textables'
  app.deployment_target = "7.0"
  app.device_family = [:iphone]
  app.interface_orientations = [:portrait, :portrait_upside_down]
  app.identifier = 'com.mohawkapps.texties'
  app.seed_id = 'DW9QQZR4ZL'
  app.version = "4"
  app.short_version = "1.1.0"
  app.icons = Dir.glob("resources/Icon*.png").map{|icon| icon.split("/").last}
  app.prerendered_icon = true
  app.info_plist['APP_STORE_ID'] = 769404785
  app.entitlements['keychain-access-groups'] = [
    app.seed_id + '.' + app.identifier
  ]

  # app.archs['iPhoneOS'] << 'arm64'
  # app.archs['iPhoneSimulator'] << 'x86_64'

  app.pods do
    pod 'UIActionSheet+Blocks'
    pod 'FlurrySDK'
    pod 'Appirater'
    pod 'Harpy'
    pod 'TestFlightSDK'
  end

  app.testflight.api_token = 'b2a3667268f446b35c4ab473259912c9_MTUwNjI'
  app.testflight.team_token = '2cf18a21ce6f6ccef94c49811c719285_MzA5NjUwMjAxMy0xMi0wNSAxODowMDoxMy4yODE0NzE'
  app.testflight.app_token = 'd1890325-9003-4dc9-a5ae-2cfa868e833f'

  app.development do
    app.entitlements['get-task-allow'] = true
    app.codesign_certificate = "iPhone Developer: Mark Rickert (YA2VZGDX4S)"
    app.provisioning_profile = "./provisioning/TextablesDevelopment.mobileprovision"
    app.testflight.identify_testers = true
  end

  app.release do
    app.entitlements['get-task-allow'] = false
    app.codesign_certificate = "iPhone Distribution: Mohawk Apps, LLC (DW9QQZR4ZL)"
    app.provisioning_profile = "./provisioning/TextablesDistribution.mobileprovision"
    app.testflight.identify_testers = false
  end
end
