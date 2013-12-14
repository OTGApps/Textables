class SectionHeader < UICollectionReusableView

  def display_string=(string)
    @display_label.text = string
  end

  def initWithFrame(frame)
    super.tap do |header|
      @display_label = UILabel.alloc.initWithFrame(header.bounds).tap do |label|
         label.textColor = UIColor.blackColor
         label.textAlignment = NSTextAlignmentCenter
         header.addSubview(label)
      end
    end
  end

  def display_label
    @display_label
  end

end
