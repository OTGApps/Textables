class PackageViewController < UICollectionViewController
  attr_accessor :data

  HEADER_IDENTIFIER = "PackageHeader"
  CELL_IDENTIFIER = "Package Cell"
  CELL_WIDTH = 150
  CELL_HEIGHT = 75

  def viewDidLoad
    self.title = "Texties"

    self.collectionView.registerClass(PackageCell, forCellWithReuseIdentifier:CELL_IDENTIFIER)
    # Package Header Needs to be registered, too
    self.collectionView.registerClass(PackageHeader,
           forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                  withReuseIdentifier: HEADER_IDENTIFIER)
    # THIS TRICKY PROPERTY MUST BE SET, OR DELEGATES AND ALL ARE IGNORED
    self.collectionView.collectionViewLayout.headerReferenceSize = CGSizeMake(10.0, 30.0)
    self.collectionView.collectionViewLayout.itemSize = CGSizeMake(CELL_WIDTH, CELL_HEIGHT)

    self.collectionView.collectionViewLayout.sectionInset = UIEdgeInsetsMake(10, 0, 10, 0)
    self.collectionView.backgroundColor = UIColor.redColor

    init_data
  end

  def init_data
    data_location = File.join(App.resources_path, "content.json")
    self.data = BW::JSON.parse(File.read(data_location))
    self.collectionView.reloadData
  end

  def collectionView(view, numberOfItemsInSection:section)
    self.data[section]["items"].count || 0
  end

  def collectionView(clv, cellForItemAtIndexPath:index_path)
    clv.dequeueReusableCellWithReuseIdentifier(CELL_IDENTIFIER, forIndexPath:index_path).tap do |cell|
      cell.art_string = self.data[index_path.section]["items"][index_path.row]["art"] || ""
      cell.title_string = self.data[index_path.section]["items"][index_path.row]["name"] || ""
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
        ap "selected person"
      end
    end

  end

end
