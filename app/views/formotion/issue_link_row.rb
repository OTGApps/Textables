module Formotion
  module RowType
    class IssueLinkRow < WebLinkRow

      def after_build(cell)
        super
        cell.imageView.image = UIImage.imageNamed("issue")
      end

      def on_select(tableView, tableViewDelegate)
        super
        Flurry.logEvent("GITHUB_ISSUE_TAPPED")
      end

    end
  end
end