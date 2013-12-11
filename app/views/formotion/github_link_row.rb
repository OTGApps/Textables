module Formotion
  module RowType
    class GithubLinkRow < WebLinkRow

      def on_select(tableView, tableViewDelegate)
        super
        Flurry.logEvent("GITHUB_TAPPED")
      end

    end
  end
end
