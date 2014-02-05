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
    @art_label.text = art_object[:art]
    @title_label.text = art_object[:name]
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

end
