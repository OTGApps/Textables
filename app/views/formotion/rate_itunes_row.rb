module Formotion
  module RowType
    class RateItunesRow < WebLinkRow

      def after_build(cell)
        super
        cell.imageView.image = UIImage.imageNamed("itunes")
      end

      def on_select(tableView, tableViewDelegate)
        Appirater.rateApp
      end

    end
  end
end
