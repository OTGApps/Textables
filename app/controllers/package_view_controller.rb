class PackageViewController < UICollectionViewController
  attr_accessor :data

  HEADER_IDENTIFIER = "PackageHeader"
  CELL_IDENTIFIER = "Package Cell"
  CELL_WIDTH = 145
  CELL_HEIGHT = 75

  def viewDidLoad
    self.title = "Texties"

    self.collectionView.registerClass(PackageCell, forCellWithReuseIdentifier:CELL_IDENTIFIER)
    # Package Header Needs to be registered, too
    self.collectionView.registerClass(PackageHeader, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: HEADER_IDENTIFIER)
    # THIS TRICKY PROPERTY MUST BE SET, OR DELEGATES AND ALL ARE IGNORED
    self.collectionView.collectionViewLayout.headerReferenceSize = CGSizeMake(10.0, 30.0)
    self.collectionView.collectionViewLayout.itemSize = CGSizeMake(CELL_WIDTH, CELL_HEIGHT)

    self.collectionView.collectionViewLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
    self.collectionView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0)
    self.collectionView.backgroundColor = "#00CC99".to_color

    init_data
  end

  def init_data
    data_location = File.join(App.resources_path, "content.json")
    self.data = BW::JSON.parse(File.read(data_location))

    self.data.unshift favorites if show_favorites?
    self.collectionView.reloadData
  end

  def favorites
    favs = {}
    favs["category"] = "Favorites"
    favs["items"] = Favorites.all_raw
    favs
  end

  def reload_favorites
    self.data.shift if self.data[0]["category"] == "Favorites"
    return unless show_favorites?
    self.data.unshift favorites
  end

  def show_favorites?
    Favorites.all_raw.count > 0
  end

  def collectionView(view, numberOfItemsInSection:section)
    self.data[section]["items"].count || 0
  end

  def collectionView(clv, cellForItemAtIndexPath:index_path)
    clv.dequeueReusableCellWithReuseIdentifier(CELL_IDENTIFIER, forIndexPath:index_path).tap do |cell|
      art = ASCIIArt.new(
        art: self.data[index_path.section]["items"][index_path.row]["art"] || "",
        name: self.data[index_path.section]["items"][index_path.row]["name"] || ""
      )
      cell.art = art
      cell.favorite = Favorites.is_favorite? cell.art
      cell.backgroundColor = UIColor.colorWithRed(1.0, green:1.0, blue:1.0, alpha:0.8)
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
    self.data.count || 0
  end

  def collectionView(clv, viewForSupplementaryElementOfKind:kind, atIndexPath:path)
    clv.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier:HEADER_IDENTIFIER, forIndexPath:path).tap do |header|
      header.display_string = self.data[path.section]["category"] || ""
    end
  end

  def collectionView(collectionView, didSelectItemAtIndexPath:indexPath)
    selected = self.data[indexPath.section]["items"][indexPath.row]

    if AddressBook.authorized?
      ap "This app is authorized!"
      show_prompt selected
    else
      if AddressBook.request_authorization
        # do something now that the user has said "yes"
        show_prompt selected
      else
        App.alert "#{App.name} doesn't have access to your contacts. You can authorize the app in your Settings.app under\nPrivacy->Contacts."
      end
    end
  end

  def show_prompt selected
    ap "Showing prompt for: #{selected}"

    fav_text = (Favorites.is_favorite? selected) ? "Remove Favorite" : "Add Favorite"

    as = UIActionSheet.alloc.initWithTitle(
      "Text: #{selected['art']}",
      delegate:nil,
      cancelButtonTitle:"Cancel",
      destructiveButtonTitle:nil,
      otherButtonTitles:fav_text, "Copy to Clipboard", "Recent Contacts", "Choose Contact", nil
    )

    as.actionSheetStyle = UIActionSheetStyleBlackTranslucent

    as.tapBlock = lambda do |actionSheet, buttonIndex|
      chose_title = actionSheet.buttonTitleAtIndex(buttonIndex)
      NSLog("Chose #{chose_title} (#{buttonIndex})")

      case buttonIndex
      when 0
        toggle_favorite selected
      when 1
        copy_to_clipboard selected
      when 3
        pick_and_send selected
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

    ap "adding_section? #{adding_section}"
    ap "deleting_section? #{deleting_section}"

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
      self.collectionView.reloadItemsAtIndexPaths(other_instances)

    }, completion:lambda {|finished|

    });

  end

  def copy_to_clipboard selected
    pb = UIPasteboard.generalPasteboard
    pb.setString selected["art"]
  end

  def pick_and_send selected
    ap "picking"
    AddressBook.pick presenter:self do |person|
      if person
        # person is an AddressBook::Person object
        ap "selected person:"
        ap person
      end
    end
  end

end
