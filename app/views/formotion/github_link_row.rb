module Formotion
  module RowType
    class GithubLinkRow < WebLinkRow

      def after_build(cell)
        super
        cell.imageView.image = UIImage.imageNamed("github")
      end

    end
  end
end
