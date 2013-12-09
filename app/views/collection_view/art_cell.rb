class ArtCell < UICollectionViewCell

  def favorite= bool
    @favorite_star.image = bool ? UIImage.imageNamed("star-highlighted") : UIImage.imageNamed("star")
  end

  def art= ascii_object
    @art = ascii_object
    @art_label.text = ascii_object.art
    @title_label.text = ascii_object.name

    if ascii_object.art.include? "\n"
      @art_label.lineBreakMode = NSLineBreakByWordWrapping
      @art_label.numberOfLines = 0
    end
  end

  def art
    @art
  end

  def initWithFrame frame
    super.tap do
      title_height = 20
      padding = 5

      title_frame = CGRectMake(
        padding, #x
        CGRectGetMaxY(self.contentView.bounds) - title_height, #y
        self.contentView.bounds.size.width - (padding*2), #w
        title_height-padding  #h
      )

      @title_label = UILabel.alloc.initWithFrame(title_frame).tap do |label|
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFontOfSize(12)
        label.textColor = UIColor.blackColor
        label.textAlignment = NSTextAlignmentCenter
        self.contentView.addSubview(label)
      end

      art_frame = CGRectMake(
        padding ,
        self.contentView.bounds.origin.y + padding,
        self.contentView.bounds.size.width - (padding * 2),
        self.contentView.bounds.size.height - title_height - padding
      )

      @art_label = UILabel.alloc.initWithFrame(art_frame).tap do |label|
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor.blackColor
        label.textAlignment = NSTextAlignmentCenter
        self.contentView.addSubview(label)
      end

      star_size = 18
      @favorite_star = UIImageView.alloc.initWithImage(UIImage.imageNamed("star")).tap do |image|
        image.frame = CGRectMake(
          CGRectGetMaxX(self.contentView.bounds) - star_size,
          0,
          star_size,
          star_size
        )
        self.contentView.addSubview(image)
      end

      layer.cornerRadius = 10
      layer.masksToBounds = true
    end
  end

  def prepareForReuse
    @art = nil
    @art_label.text = ""
    @title_label.text = ""
    @art_label.numberOfLines = 1
  end

end
