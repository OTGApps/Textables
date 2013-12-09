module Formotion
  module RowType
    class ShareRow < ActivityRow

      def after_build(cell)
        super
        cell.imageView.image = UIImage.imageNamed("share")
      end

    end
  end
end
