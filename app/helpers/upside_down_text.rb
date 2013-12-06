class UpsideDownText
  def self.convert text
    regexp_keys = Regexp.union(UpsideDownText.char_table.keys)
    text.downcase.reverse.gsub(regexp_keys, char_table)
  end

  def self.char_table
    {
      "a" => 'ɐ',
      "b" => 'q',
      "c" => 'ɔ',
      "d" => 'p',
      "e" => 'ә',
      "f" => 'ɟ',
      "g" => 'ƃ',
      "h" => 'Ⴁ',
      "i" => '!',
      "j" => 'ɾ',
      "k" => 'ʞ',
      "l" => 'Ⴈ',
      "m" => 'ɯ',
      "n" => 'u',
      "r" => 'ɹ',
      "t" => 'ʇ',
      "v" => 'ʌ',
      "w" => 'ʍ',
      "y" => 'ʎ',
      "!" => 'i'
    }
  end

end
