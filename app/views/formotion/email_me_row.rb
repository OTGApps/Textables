module Formotion
  module RowType
    class EmailMeRow < WebLinkRow

      def after_build(cell)
        super
        cell.imageView.image = UIImage.imageNamed("email")
      end

      def on_select(tableView, tableViewDelegate)
        BW::Mail.compose({
          delegate: row.form.controller,
          to: row.value[:to],
          subject: row.value[:subject],
          message: "",
          animated: true
        })
      end

    end
  end
end
