module Formotion
  module RowType
    class GithubLinkRow < WebLinkRow

      def after_build(cell)
        super
        cell.imageView.image = UIImage.imageNamed("github")
      end

      def on_select(tableView, tableViewDelegate)
        super
        Flurry.logEvent("GITHUB_TAPPED")
      end

    end
  end
end
