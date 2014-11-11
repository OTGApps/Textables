class TextablesAPI
  API_URL = "https://raw.github.com/MohawkApps/Textables/master/resources/content.json"

  def self.textify
    mp "Getting textables from github."

    AFMotion::HTTP.get(API_URL, q: Time.now.to_i) do |result|
      if result.success?
        old_count = TextablesData.sharedData.textables_count

        mp result.body

        # Save it to the filesystem
        path_name = 'content.json'
        path_name.remove_file! if path_name.file_exists?
        NSFileManager.defaultManager.createFileAtPath(path_name.document_path, contents: result.body, attributes: nil)

        App::Persistence['last_checked_texties'] = Time.now.to_i
        TextablesData.sharedData.cleanup

        new_count = TextablesData.sharedData.textables_count
        Flurry.logEvent("API_HIT", withParameters:{old_count: old_count, new_count: new_count}) unless Device.simulator?

        if new_count > old_count
          NSLog "Got #{new_count - old_count} new texties."
          App.alert("New #{App.name} added:", message: "We just added #{new_count - old_count} new #{App.name}!\nEnjoy!")
        end

        App.notification_center.post 'ReloadTextablesNotification'
      else
        NSLog("Error: Can not retrieve textables from github.")
        Flurry.logEvent("API_ERROR") unless Device.simulator?
      end
    end
  end
end
