module Formotion
  module RowType
    class RateItunesRow < WebLinkRow

      def on_select(tableView, tableViewDelegate)
        Appirater.rateApp
      end

    end
  end
end
