class TextablesAPI
  API_URL = "https://raw.github.com/MohawkApps/Textables/master/resources/content.json"

  def self.textify(&block)
    BW::HTTP.get(API_URL) do |response|
        json = nil
        error = nil

        if response.ok?
          json = response.body.to_str
        else
          error = {error: "sorry"}
        end

        block.call json, error
    end
  end
end
