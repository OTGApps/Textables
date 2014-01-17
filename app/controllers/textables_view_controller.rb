class TextablesViewController < UICollectionViewController
  attr_accessor :data

  HEADER_IDENTIFIER = "SectionHeader"
  CELL_IDENTIFIER = "Package Cell"
  CELL_WIDTH = 145
  CELL_HEIGHT = 75

  def viewDidLoad
    super
    self.title = App.name

    self.collectionView.registerClass(ArtCell, forCellWithReuseIdentifier:CELL_IDENTIFIER)
    # Package Header Needs to be registered, too
    self.collectionView.registerClass(SectionHeader, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: HEADER_IDENTIFIER)
    # THIS TRICKY PROPERTY MUST BE SET, OR DELEGATES AND ALL ARE IGNORED
    self.collectionView.collectionViewLayout.headerReferenceSize = CGSizeMake(10.0, 30.0)
    self.collectionView.collectionViewLayout.itemSize = CGSizeMake(CELL_WIDTH, CELL_HEIGHT)

    self.collectionView.collectionViewLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
    self.collectionView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0)
    self.collectionView.backgroundColor = "#00CC99".to_color

    # Info Button
    info_image = UIImage.imageNamed "info"
    info_button = UIBarButtonItem.alloc.initWithImage(info_image, style:UIBarButtonItemStylePlain, target:self, action:"show_about")
    self.navigationItem.rightBarButtonItem = info_button

    # Crazy Letters Button
    crazy_letters_button = UIBarButtonItem.alloc.initWithTitle("crazy".kanjify, style:UIBarButtonItemStylePlain, target:self, action:"crazy_text:")
    self.navigationItem.leftBarButtonItem = crazy_letters_button

  end

  def viewWillAppear animated
    super
    init_data
  end

  def viewDidAppear animated
    super
    fetch_data if needs_textification
  end

  def needs_textification
    # Don't check the server if the launch count is under 2
    return false if App::Persistence['motion_takeoff_launch_count'] < 2 && !Device.simulator?

    time = (Device.simulator?) ? 20.seconds.ago.to_i : 2.days.ago.to_i
    App::Persistence['last_checked_texties'].nil? || time > App::Persistence['last_checked_texties']
  end

  def fetch_data
    # Fetch and save the data locally.
    old_count = TextablesData.sharedData.textables_count
    TextablesAPI.textify do |text, error|
      if error.nil? && text[0] == "["
        File.open(TextablesData.sharedData.documents, 'w') { |file| file.write(text) }
        App::Persistence['last_checked_texties'] = Time.now.to_i
        TextablesData.sharedData.cleanup
        new_count = TextablesData.sharedData.textables_count

        Flurry.logEvent("API_HIT", withParameters:{old_count: old_count, new_count: new_count}) unless Device.simulator?
        NSLog "Got valid result from #{App.name} server. Old:#{old_count} New:#{new_count}"
        if new_count > old_count
          NSLog "Got #{new_count - old_count} new texties."
          App.alert("New #{App.name} added:", message: "We just added #{new_count - old_count} new #{App.name}!\nEnjoy!")
        end

        init_data
      else
        NSLog "Error retrieving data from the #{App.name} server."
      end
    end
  end

  def init_data
    self.data = TextablesData.sharedData.json
    reload_favorites
    self.collectionView.reloadData
  end

  def show_about
    Flurry.logEvent("SHOW_ABOUT") unless Device.simulator?
    about_vc = AboutViewController.alloc.init
    nav_controller = UINavigationController.alloc.initWithRootViewController(about_vc)
    self.presentViewController(nav_controller, animated:true, completion:nil)
  end

  def favorites
    favs = {}
    favs["category"] = "Favorites"
    favs["items"] = Favorites.all
    favs
  end

  def reload_favorites
    self.data.shift if self.data[0]["category"] == "Favorites"
    return unless show_favorites?
    self.data.unshift favorites
  end

  def show_favorites?
    Favorites.all.count > 0
  end

  def collectionView(view, numberOfItemsInSection:section)
    self.data[section]["items"].reject{|i| i['name'] == "" }.count || 0
  end

  def collectionView(clv, cellForItemAtIndexPath:index_path)
    art = {
      art: self.data[index_path.section]["items"][index_path.row]["art"],
      name: self.data[index_path.section]["items"][index_path.row]["name"]
    }

    clv.dequeueReusableCellWithReuseIdentifier(CELL_IDENTIFIER, forIndexPath:index_path).tap do |cell|
      cell.art = art
      cell.favorite = Favorites.is_favorite? art
      cell.backgroundColor = UIColor.colorWithRed(1.0, green:1.0, blue:1.0, alpha:0.8)
      cell.opaque = true
    end
  end

  def index_paths_for_art(art, this_data=nil)
    this_data = self.data if this_data.nil?
    art = art["art"] if art.is_a? Hash

    # ap "Finding paths of art: #{art}"
    ips = []
    this_data.each_with_index do |section, s_idx|
      section["items"].each_with_index do |item, idx|
        if item["art"] == art
          # ap "found: #{item['art']} at [#{idx},#{s_idx}]"
          ips << NSIndexPath.indexPathForRow(idx, inSection:s_idx)
        end
      end
    end
    ips
  end

  def numberOfSectionsInCollectionView(clv)
    self.data.reject{|d| d['category'] == ""}.count || 0
  end

  def collectionView(clv, viewForSupplementaryElementOfKind:kind, atIndexPath:path)
    clv.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier:HEADER_IDENTIFIER, forIndexPath:path).tap do |header|
      header.display_string = self.data[path.section]["category"] || ""
    end
  end

  def collectionView(collectionView, didSelectItemAtIndexPath:indexPath)
    selected = self.data[indexPath.section]["items"][indexPath.row]
    show_prompt selected
  end

  def show_prompt selected, can_favorite = true
    selected_art = (selected.is_a?(String)) ? selected : selected['art']

    if can_favorite

      fav_text = (Favorites.is_favorite? selected) ? "Remove Favorite" : "Add Favorite"
      as = UIActionSheet.alloc.initWithTitle(
        "Text: #{selected_art}",
        delegate:nil,
        cancelButtonTitle:"Cancel",
        destructiveButtonTitle:nil,
        otherButtonTitles:fav_text, "Copy to Clipboard", "Send To...", nil
      )

    else

      as = UIActionSheet.alloc.initWithTitle(
        "Text: #{selected_art}",
        delegate:nil,
        cancelButtonTitle:"Cancel",
        destructiveButtonTitle:nil,
        otherButtonTitles:"Copy to Clipboard", "Send To...", nil
      )

    end

    as.actionSheetStyle = UIActionSheetStyleBlackTranslucent

    as.tapBlock = lambda do |actionSheet, buttonIndex|
      chose_title = actionSheet.buttonTitleAtIndex(buttonIndex)
      # NSLog("Chose #{chose_title} (#{buttonIndex})")

      if can_favorite

        case buttonIndex
        when 0
          toggle_favorite selected
        when 1
          copy_to_clipboard selected_art
        when 2
          pick_and_send selected_art
        end

      else

        case buttonIndex
        when 0
          copy_to_clipboard selected_art
        when 1
          pick_and_send selected_art
        end

      end

    end

    as.showInView(self.view)

  end

  def toggle_favorite art
    # ap "Toggling favorite for #{art}"
    adding = Favorites.is_favorite? art

    old_count = Favorites.count
    old_data = self.data.copy
    Favorites.toggle art
    reload_favorites
    new_count = Favorites.count

    adding_section = (new_count > 0 && old_count == 0)
    deleting_section = (new_count == 0)

    all_instances = index_paths_for_art(art, old_data)
    favorites_instances = all_instances.reject{|p| p.section != 0 }
    other_instances = all_instances.reject{|p| p.section == 0 }

    self.collectionView.performBatchUpdates(lambda {
      if adding_section
        # Add the favorites section
        self.collectionView.insertSections(NSIndexSet.indexSetWithIndex(0))
      elsif deleting_section
        # Remove the favorites section
        self.collectionView.deleteSections(NSIndexSet.indexSetWithIndex(0))
      elsif new_count > old_count
        # Add the item to the end of the collection view section
        self.collectionView.insertItemsAtIndexPaths([NSIndexPath.indexPathForRow(old_count, inSection:0)])
      else
        # Find the index path of this particular art and delete from the top section
        self.collectionView.deleteItemsAtIndexPaths(favorites_instances)
      end

    }.weak!, completion:lambda {|finished|
        all_instances = index_paths_for_art(art)
        self.collectionView.reloadItemsAtIndexPaths(all_instances)
    }.weak!)

  end

  def copy_to_clipboard selected
    Flurry.logEvent("COPY", withParameters:{art: selected}) unless Device.simulator?
    UIPasteboard.generalPasteboard.setString(selected)
    Motion::Blitz.success("Copied!")
  end

  def pick_and_send selected
    items = [selected]
    Flurry.logEvent("SHARE", withParameters:{art: selected}) unless Device.simulator?

    activity_vc = UIActivityViewController.alloc.initWithActivityItems(items, applicationActivities:nil)
    activity_vc.modalTransitionStyle = UIModalTransitionStyleCoverVertical
    activity_vc.excludedActivityTypes = TextablesUtils.excluded_services

    self.presentViewController(activity_vc, animated:true, completion:nil)
  end

  def crazy_text sender

    as = UIActionSheet.alloc.initWithTitle(
      "What kind of text?",
      delegate:nil,
      cancelButtonTitle:"Cancel",
      destructiveButtonTitle:nil,
      otherButtonTitles:'crazy text'.kanjify, 'upside down text'.upside_down, nil
    )
    as.actionSheetStyle = UIActionSheetStyleBlackTranslucent

    as.tapBlock = lambda do |actionSheet, buttonIndex|
      case buttonIndex
      when 0
        prompt_for_crazy
      when 1
        prompt_for_upsidedown
      end
    end.weak!

    as.showInView(self.view)

  end

  def prompt_for_crazy
    alert = BW::UIAlertView.plain_text_input(:title => "Create your own\n" << "crazy text".kanjify << "!") do |alert|
      if alert.clicked_button.index != 0
        s = "#{alert.plain_text_field.text}"
        show_prompt(s.kanjify, false)
      end
    end

    alert.show
  end

  def prompt_for_upsidedown
    alert = BW::UIAlertView.plain_text_input(:title => "Create your own\n" << "upside down text!".upside_down) do |alert|
      if alert.clicked_button.index != 0
        s = "#{alert.plain_text_field.text}"
        show_prompt(s.upside_down, false)
      end
    end

    alert.show
  end

  def didReceiveMemoryWarning
    super
    Flurry.logEvent("MEMORY_WARNING") unless Device.simulator?
  end

end
