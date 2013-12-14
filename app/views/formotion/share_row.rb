module Formotion
  module RowType
    class ShareRow < ActivityRow

      def on_select(tableView, tableViewDelegate)
        super
        Flurry.logEvent("SHARE_TAPPED") unless Device.simulator?
      end

    end
  end
end
