class TextablesStylesheet < ApplicationStylesheet

  include ArtCellStylesheet

  def setup
    # Add stylesheet specific setup stuff here.
    # Add application specific setup stuff in application_stylesheet.rb

  end

  def collection_view(st)
    st.view.contentInset = [10, 0, 0, 0]
    st.background_color = '#00CC99'.to_color

    st.view.collectionViewLayout.tap do |cl|
      cl.itemSize = [cell_size[:w], cell_size[:h]]
      cl.scrollDirection = UICollectionViewScrollDirectionVertical
      cl.headerReferenceSize = [cell_size[:w], cell_size[:h]]
      cl.sectionInset = [10,10,10,10]
    end
  end
end
