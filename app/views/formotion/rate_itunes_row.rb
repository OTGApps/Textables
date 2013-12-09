module Formotion
  module RowType
    class RateItunesRow < WebLinkRow

      def after_build(cell)
        super
        cell.imageView.image = UIImage.imageNamed("itunes")
      end

      def on_select(tableView, tableViewDelegate)
        Appirater.rateApp
        Flurry.logEvent("RATE_ITUNES_TAPPED")
      end

    end
  end
end
