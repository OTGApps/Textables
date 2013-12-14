module Formotion
  module RowType
    class GithubLinkRow < WebLinkRow

      def on_select(tableView, tableViewDelegate)
        super
        Flurry.logEvent("GITHUB_TAPPED") unless Device.simulator?
      end

    end
  end
end
