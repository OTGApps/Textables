class TextablesAPI
  API_URL = "https://raw.github.com/MohawkApps/Textables/master/resources/content.json"

  def self.textify(&block)
    ap "Getting textables from github."

    AFMotion::HTTP.get(API_URL, q: Time.now.to_i) do |result|
      json = nil
      error = nil

      if result.success?
        json ||= result.body
      else
        error ||= {error: "sorry"}
      end
      block.call(json, error)
    end
  end
end
