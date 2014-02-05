class ArtCell < UICollectionViewCell
  attr_reader :title_label, :art_label

  def favorite=(fav)
    star = fav ? 'star-highlighted' : 'star'
    @fav_star.image = UIImage.imageNamed(star)
  end

  def art=(art_object)
    @art_label.text = art_object[:art]
    @title_label.text = art_object[:name]
  end

  def art
    {
      art: @art_label.text,
      title: @title_label.text
    }
  end

  def initWithFrame(frame)
    super.tap do
      title_height = 20
      padding = 5

      title_frame = CGRectMake(
        padding, # x
        CGRectGetMaxY(contentView.bounds) - title_height, # y
        contentView.bounds.size.width - (padding * 2), # w
        title_height - padding  # h
      )

      @title_label = UILabel.alloc.initWithFrame(title_frame).tap do |label|
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFontOfSize(12)
        label.textColor = UIColor.blackColor
        label.textAlignment = NSTextAlignmentCenter
        contentView.addSubview(label)
      end

      art_frame = CGRectMake(
        padding ,
        contentView.bounds.origin.y + padding,
        contentView.bounds.size.width - (padding * 2),
        contentView.bounds.size.height - title_height - padding
      )

      @art_label = UILabel.alloc.initWithFrame(art_frame).tap do |label|
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor.blackColor
        label.textAlignment = NSTextAlignmentCenter
        contentView.addSubview(label)
      end

      star_size = 18
      star_image = UIImage.imageNamed('star')
      @fav_star = UIImageView.alloc.initWithImage(star_image).tap do |image|
        star_padding = 3
        image.frame = CGRectMake(
          CGRectGetMaxX(contentView.bounds) - star_size - star_padding,
          star_padding,
          star_size,
          star_size
        )
        contentView.addSubview(image)
      end
      contentView.backgroundColor = '#cdf5eb'.to_color
    end
  end

  def prepareForReuse
    @art_label.text = ''
    @title_label.text = ''
  end
end
