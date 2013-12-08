module Formotion
  module RowType
    class WebLinkRow < StaticRow

      attr_accessor :link

      def after_build(cell)
        super

        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
        self.row.text_field.hidden = true

        if (row.value.is_a?(String) && row.value[0..3] == "http") || row.value.is_a?(NSURL)
          row.on_tap do |r|
            App.open_url row.value
          end
        end

      end
    end
  end
end
