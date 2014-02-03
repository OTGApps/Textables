class TextablesAPI

  API_URL = "https://raw.github.com/MohawkApps/Textables/master/resources/content.json"

  def self.textify(&block)

    AFMotion::JSON.get(API_URL) do |result|
      ap result.error.localizedDescription if BW.debug?
      text = nil
      error = nil

      if result.success?
        text = result.body.to_str
      else
        error = {error: "sorry"}
      end

      block.call text, error
    end
  end

end
