class TextiesAPI

  APIURL = "https://raw.github.com/MohawkApps/Texties/master/resources/content.json"

  def self.textify(&block)

    BW::HTTP.get(APIURL) do |response|
        text = nil
        error = nil

        if response.ok?
          text = response.body.to_str
        else
          error = {error: "sorry"}
        end

        block.call text, error
    end
  end

end
