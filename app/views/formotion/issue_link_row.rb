module Formotion
  module RowType
    class IssueLinkRow < WebLinkRow

      def on_select(tableView, tableViewDelegate)
        super
        Flurry.logEvent("GITHUB_ISSUE_TAPPED") unless Device.simulator?
      end

    end
  end
end
