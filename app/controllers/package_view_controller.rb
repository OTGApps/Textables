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
    self.collectionView.backgroundColor = "#00CC99".to_color

    init_data
  end

  def init_data
    data_location = File.join(App.resources_path, "content.json")
    self.data = BW::JSON.parse(File.read(data_location))

    self.data.unshift favorites_data if show_favorites?
    self.collectionView.reloadData
  end

  def show_favorites?
    Favorites.all_raw.count > 0
  end

  def favorites_data
    favs = {}
    favs["category"] = "Favorites"
    favs["items"] = Favorites.all_raw
    favs
  end

  def reload_favorites
    self.data.shift if self.data[0]["category"] == "Favorites"
    return unless show_favorites?
    self.data.unshift favorites_data
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

      cell.when_pressed do |c|
        if c.state == UIGestureRecognizerStateBegan

          self.collectionView.performBatchUpdates(lambda {
            old_count = Favorites.count
            Favorites.toggle c.view.art
            reload_favorites
            new_count = Favorites.count

            if new_count == 1
              self.collectionView.insertSections(NSIndexSet.indexSetWithIndex(0))
            elsif new_count == 0
              self.collectionView.deleteSections(NSIndexSet.indexSetWithIndex(0))
            elsif new_count > old_count
              self.collectionView.insertItemsAtIndexPaths([NSIndexPath.indexPathForRow(old_count, inSection:0)])
            else
              self.collectionView.deleteItemsAtIndexPaths([NSIndexPath.indexPathForRow(new_count, inSection:0)])
            end

            # if index_path.section > 0
            #   self.collectionView.reloadItemsAtIndexPaths [index_path]
            # else
            #   self.collectionView.reloadData
            # end

            # self.collectionView.reloadSections NSIndexSet.indexSetWithIndex(0)
          }, completion:lambda {|finished|

          });
        end
      end
    end
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

    as = UIActionSheet.alloc.initWithTitle(
      "Text: #{selected['art']}",
      delegate:nil,
      cancelButtonTitle:"Cancel",
      destructiveButtonTitle:nil,
      otherButtonTitles:"Copy to Clipboard", "Recent Contacts", "Choose Contact", nil
    )

    as.actionSheetStyle = UIActionSheetStyleBlackTranslucent

    as.tapBlock = lambda do |actionSheet, buttonIndex|
      chose_title = actionSheet.buttonTitleAtIndex(buttonIndex)
      NSLog("Chose #{chose_title} (#{buttonIndex})")

      case buttonIndex
      when 0
        copy_to_clipboard selected
      when 2
        pick_and_send selected
      end

    end

    as.showInView(self.view)

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
