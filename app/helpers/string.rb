class String

  def upside_down
    char_table = {
      'a' => 'ɐ',
      'b' => 'q',
      'c' => 'ɔ',
      'd' => 'p',
      'e' => 'ә',
      'f' => 'ɟ',
      'g' => 'ƃ',
      'h' => 'ɥ',
      'i' => 'ᴉ',
      'j' => 'ɾ',
      'k' => 'ʞ',
      'm' => 'ɯ',
      'n' => 'u',
      'p' => 'd',
      'q' => 'b',
      'r' => 'ɹ',
      't' => 'ʇ',
      'u' => 'n',
      'v' => 'ʌ',
      'w' => 'ʍ',
      'y' => 'ʎ',
      '!' => '¡',
      '¿' => '¿'
    }

    regexp_keys = Regexp.union(char_table.keys)
    self.downcase.reverse.gsub(regexp_keys, char_table)
  end

  def kanjify
    char_table = {
      'a' => 'ﾑ',
      'b' => '乃',
      'c' => 'c',
      'd' => 'd',
      'e' => '乇',
      'f' => 'ｷ',
      'g' => 'g',
      'h' => 'ん',
      'i' => 'ﾉ',
      'j' => 'ﾌ',
      'k' => 'ズ',
      'l' => 'ﾚ',
      'm' => 'ﾶ',
      'n' => '刀',
      'o' => 'o',
      'p' => 'ｱ',
      'q' => 'q',
      'r' => '尺',
      's' => '丂',
      't' => 'ｲ',
      'u' => 'u',
      'v' => '√',
      'w' => 'w',
      'x' => 'ﾒ',
      'y' => 'ﾘ',
      'z' => '乙'
    }

    regexp_keys = Regexp.union(char_table.keys)
    self.downcase.gsub(regexp_keys, char_table)
  end

end
