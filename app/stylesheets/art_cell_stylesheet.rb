module ArtCellStylesheet
  def cell_size
    { w: 145, h: 75 }
  end

  def padding
    5
  end

  def title_height
    20
  end

  def art_cell(st)
    st.frame = cell_size
    st.background_color = '#cdf5eb'.to_color
    st.layer.cornerRadius = 5
    st.layer.masksToBounds = true
  end

  def title_label(st)
    st.frame = CGRectMake(
      padding, # x
      cell_size[:h] - title_height, # y
      cell_size[:w] - (padding * 2), # w
      title_height - padding  # h
    )
    st.adjusts_font_size = true
    st.font = UIFont.systemFontOfSize(12)
    st.color = UIColor.blackColor
    st.text_alignment = :center
    st.number_of_lines = 1
  end

  def art_label(st)
    st.frame = CGRectMake(
      padding ,
      padding,
      cell_size[:w] - (padding * 2),
      cell_size[:h] - title_height - padding
    )
    st.adjusts_font_size = true
    st.color = UIColor.blackColor
    st.text_alignment = :center
    st.number_of_lines = 1
  end

  def fav_star(st)
    star_size = 18
    star_padding = 3

    st.frame = CGRectMake(
      cell_size[:w] - star_size - star_padding,
      star_padding,
      star_size,
      star_size
    )
    st.image = UIImage.imageNamed('star')
  end

end
