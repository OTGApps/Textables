module Formotion
  module RowType
    class IssueLinkRow < WebLinkRow

      def after_build(cell)
        super

        cell.imageView.image = UIImage.imageNamed("issue")
      end

    end
  end
end
