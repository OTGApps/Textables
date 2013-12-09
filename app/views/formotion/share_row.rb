module Formotion
  module RowType
    class ShareRow < ActivityRow

      def after_build(cell)
        super
        cell.imageView.image = UIImage.imageNamed("share")
      end

      def on_select(tableView, tableViewDelegate)
        super
        Flurry.logEvent("SHARE_TAPPED")
      end

    end
  end
end
