class TextablesUtils

  def self.excluded_services
    [
      UIActivityTypeAddToReadingList,
      UIActivityTypeAirDrop,
      UIActivityTypeCopyToPasteboard,
      UIActivityTypePrint
    ]
  end

end
