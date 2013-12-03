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
            favorites_index_path = indexPathForArt(c.view.art.art, inSection:0)
            reload_favorites
            new_count = Favorites.count

            adding_favorites = (new_count > 0 && old_count == 0)
            deleting_favorites = (new_count == 0)

            if adding_favorites
              # Add the favorites section
              self.collectionView.insertSections(NSIndexSet.indexSetWithIndex(0))
            elsif deleting_favorites
              # Remove the favorites section
              self.collectionView.deleteSections(NSIndexSet.indexSetWithIndex(0))
            elsif new_count > old_count
              # Add the item to the end of the collection view section
              self.collectionView.insertItemsAtIndexPaths([NSIndexPath.indexPathForRow(old_count, inSection:0)])
            else
              # Find the index path of this particular art and delete from the top section
              self.collectionView.deleteItemsAtIndexPaths([favorites_index_path])
            end

            ap index_path.section
            if index_path.section > 0 || adding_favorites
              ap "reloading item"
              self.collectionView.reloadItemsAtIndexPaths [index_path]
            # else
            #   ap "finding and reloading item."
            #   found_index = indexPathForArt(c.view.art.art)
            #   self.collectionView.reloadItemsAtIndexPaths [found_index] if found_index
            end

          }, completion:lambda {|finished|

          });
        end
      end
    end
  end

  def indexPathForArt art, inSection:section
    ap "Finding path of art: #{art}"
    self.data[section]["items"].each_with_index do |item, index|
      ap "index: #{index}, item: #{item}"
      if item["art"] == art
        ap "found: #{item['art']} at [#{index},#{section}]"
        return NSIndexPath.indexPathForRow(index, inSection:section)
      end
    end
    nil
  end

  def indexPathForArt art
    ap "Finding path of art: #{art}"
    self.data.each_with_index do |section, s_idx|
      section["items"].each_with_index do |item, idx|
        if item["art"] == art
          ap "found: #{item['art']} at [#{idx},#{s_idx}]"
          return NSIndexPath.indexPathForRow(idx, inSection:s_idx)
        end
      end
    end
    nil
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
