class TextablesViewController < UICollectionViewController
  attr_accessor :data

  COLLECTION_CELL_ID = "ArtCell"
  COLLECTION_HEADER_ID = "SectionHeader"

  def self.new(args = {})
    # Set layout
    layout = UICollectionViewFlowLayout.alloc.init
    self.alloc.initWithCollectionViewLayout(layout)
  end

  def viewDidLoad
    super

    self.title = App.name

    rmq.stylesheet = TextablesStylesheet

    collectionView.tap do |cv|
      cv.registerClass(ArtCell, forCellWithReuseIdentifier: COLLECTION_CELL_ID)
      cv.registerClass(SectionHeader, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: COLLECTION_HEADER_ID)
      cv.delegate = self
      cv.dataSource = self
      cv.allowsSelection = true
      cv.allowsMultipleSelection = false
      rmq(cv).apply_style :collection_view
    end

    # Info Button
    info_image = UIImage.imageNamed 'info'
    info_button = UIBarButtonItem.alloc.initWithImage(info_image, style:UIBarButtonItemStylePlain, target:self, action:'show_about')
    self.navigationItem.rightBarButtonItem = info_button

    # Crazy Letters Button
    crazy_letters_button = UIBarButtonItem.alloc.initWithTitle('crazy'.kanjify, style:UIBarButtonItemStylePlain, target:self, action:'crazy_text:')
    self.navigationItem.leftBarButtonItem = crazy_letters_button
  end

  def viewWillAppear animated
    super
    init_data
  end

  def viewDidAppear animated
    super
    fetch_data if TextablesData.needs_textification?
  end

  def fetch_data
    # Fetch and save the data locally.
    ap "Fetching new data from the server"

    old_count = TextablesData.sharedData.textables_count
    TextablesAPI.textify do |json, error|
      if error.nil? && json[0] == "["
        ap "Saving Data file to filesystem."

        File.open(TextablesData.sharedData.documents, 'w') { |file| file.write(json) }
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

  def index_paths_for_art(art, this_data=nil)
    this_data = self.data if this_data.nil?
    art = art["art"] if art.is_a? Hash

    ap "Finding paths of art: #{art}"
    ips = []
    this_data.each_with_index do |section, s_idx|
      section["items"].each_with_index do |item, idx|
        if item["art"] == art
          ap "found: #{item['art']} at [#{idx},#{s_idx}]"
          ips << NSIndexPath.indexPathForRow(idx, inSection:s_idx)
        end
      end
    end
    ips
  end

  def numberOfSectionsInCollectionView(view)
    self.data.reject{|d| d['category'] == ""}.count || 0
  end

  def collectionView(view, numberOfItemsInSection: section)
    self.data[section]["items"].reject{|i| i['name'] == "" }.count || 0
  end

  def collectionView(view, cellForItemAtIndexPath: index_path)
    view.dequeueReusableCellWithReuseIdentifier(COLLECTION_CELL_ID, forIndexPath: index_path).tap do |cell|
      rmq.build(cell) unless cell.reused

      art = {
        art: self.data[index_path.section]["items"][index_path.row]["art"],
        name: self.data[index_path.section]["items"][index_path.row]["name"]
      }
      cell.art = art
      cell.favorite = Favorites.is_favorite? art
    end
  end

  def collectionView(view, didSelectItemAtIndexPath: index_path)
    # cell = view.cellForItemAtIndexPath(index_path)
    puts "Selected at section: #{index_path.section}, row: #{index_path.row}"

    selected = self.data[index_path.section]["items"][index_path.row]
    show_prompt selected
  end

  def collectionView(clv, viewForSupplementaryElementOfKind:kind, atIndexPath:path)
    clv.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier:COLLECTION_HEADER_ID, forIndexPath:path).tap do |header|
      header.display_string = self.data[path.section]["category"] || ""
    end
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
    ap "Toggling favorite for #{art}"
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
    Flurry.logEvent("SHARE", withParameters:{art: selected}) unless Device.simulator?

    activity_vc = UIActivityViewController.alloc.initWithActivityItems([selected], applicationActivities:nil)
    activity_vc.modalTransitionStyle = UIModalTransitionStyleCoverVertical
    activity_vc.excludedActivityTypes = TextablesData.excluded_services
    self.presentViewController(activity_vc, animated:true, completion:nil)

    # Switch to this once this pull request is integrated into BubbleWrap:
    # https://github.com/rubymotion/BubbleWrap/pull/335
    #
    # activity_vc = BW::UIActivityViewController.new(
    #   items: selected,
    #   excluded: TextablesData.excluded_services
    # ) do |activity_type, completed|
    #   ap "Completed dialog - activity: #{activity_type} - finished flag: #{completed}"
    # end

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
