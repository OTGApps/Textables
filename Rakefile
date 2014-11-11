# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'
require "rubygems"
require 'bundler'
Bundler.require

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'Textables'

  app.version = (`git rev-list HEAD --count`.strip.to_i).to_s
  app.short_version = '1.1.3'

  app.sdk_version = "8.1"
  app.deployment_target = "7.1"

  app.device_family = [:iphone]
  app.interface_orientations = [:portrait, :portrait_upside_down]

  app.identifier = 'com.mohawkapps.texties'
  app.icons = Dir.glob("resources/Icon*.png").map{|icon| icon.split("/").last}
  app.prerendered_icon = true
  app.info_plist['APP_STORE_ID'] = 769404785

  app.pods do
    pod 'UIActionSheet+Blocks'
    pod 'FlurrySDK'
    pod 'Appirater'
    pod 'Harpy'
  end

  app.development do
    app.seed_id = '7N372VT8HB'
    app.identifier = app.seed_id + '.' + app.identifier
    app.entitlements['keychain-access-groups'] = [
      app.identifier
    ]
    app.entitlements['get-task-allow'] = true
    app.codesign_certificate = "iPhone Developer: Mark Rickert (YA2VZGDX4S)"
    app.provisioning_profile = "../Provisioning/WildcardDevelopment.mobileprovision"
  end

  app.release do
    app.info_plist['AppStoreRelease'] = true
    app.entitlements['get-task-allow'] = false
    app.codesign_certificate = "iPhone Distribution: Mohawk Apps, LLC (DW9QQZR4ZL)"
    app.provisioning_profile = "./provisioning/TextablesDistribution.mobileprovision"
  end
end
