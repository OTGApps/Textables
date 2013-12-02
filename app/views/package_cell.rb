class PackageCell < UICollectionViewCell
  def art_string= string
    @art_label.text = string
  end

  def title_string= string
    @title_label.text = string
  end

  def initWithFrame frame
    super.tap do
      title_height = 20

      title_frame = CGRectMake(
        0, #x
        CGRectGetMaxY(self.contentView.bounds) - title_height, #y
        self.contentView.bounds.size.width, #w
        title_height  #h
      )

      @title_label = UILabel.alloc.initWithFrame(title_frame).tap do |label|
        label.backgroundColor = UIColor.blueColor
        label.textColor = UIColor.blackColor
        label.textAlignment = NSTextAlignmentCenter
        self.contentView.addSubview(label)
      end

      art_frame = [self.contentView.bounds.origin, [self.contentView.bounds.size.width, self.contentView.bounds.size.height - title_height]]

      @art_label = UILabel.alloc.initWithFrame(art_frame).tap do |label|
        label.adjustsFontSizeToFitWidth = true
        label.backgroundColor = UIColor.greenColor
        label.textColor = UIColor.blackColor
        label.textAlignment = NSTextAlignmentCenter
        self.contentView.addSubview(label)
      end
    end
  end
end
