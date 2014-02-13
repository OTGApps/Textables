class ArtCell < UICollectionViewCell
  attr_reader :reused, :title_label, :art_label

  def rmq_build
    rmq(self).apply_style :art_cell
    rmq(self.contentView).tap do |q|
      @title_label = q.append(UILabel, :title_label).get
      @art_label = q.append(UILabel, :art_label).get
      @fav_star = q.append(UIImageView, :fav_star).get
    end
  end

  def favorite=(fav)
    star = fav ? 'star-highlighted' : 'star'
    @fav_star.image = UIImage.imageNamed(star)
  end

  def art=(art_object)
    # art_string = art_object[:art].mutableCopy
    # search_unicode_heart.each {|search| art_string.gsub!(search, replace_unicode_heart)}

    @art_label.setText art_object[:art]
    @title_label.setText art_object[:name]
  end

  def art
    {
      art: @art_label.text,
      title: @title_label.text
    }
  end

  def prepareForReuse
    @reused = true
    @art_label.text = ''
    @title_label.text = ''
  end

  # def search_unicode_heart
  #   ['❤', '♥']
  # end

  # def replace_unicode_heart
  #   @unicode_heart ||= '♥' <<  [0x0000FE0E].pack('U*')
  # end

end
