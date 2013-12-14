module Formotion
  module RowType
    class RateItunesRow < WebLinkRow

      def on_select(tableView, tableViewDelegate)
        Appirater.rateApp
        Flurry.logEvent("RATE_ITUNES_TAPPED") unless Device.simulator?
      end

    end
  end
end
