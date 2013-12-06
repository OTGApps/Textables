class CrazyText

  def self.convert text
    regexp_keys = Regexp.union(CrazyText.char_table.keys)
    text.downcase.gsub(regexp_keys, char_table)
  end

  def self.char_table
    {
      "a" => "ﾑ",
      "b" => "乃",
      "c" => "c",
      "d" => "d",
      "e" => "乇",
      "f" => "ｷ",
      "g" => "g",
      "h" => "ん",
      "i" => "ﾉ",
      "j" => "ﾌ",
      "k" => "ズ",
      "l" => "ﾚ",
      "m" => "ﾶ",
      "n" => "刀",
      "o" => "o",
      "p" => "ｱ",
      "q" => "q",
      "r" => "尺",
      "s" => "丂",
      "t" => "ｲ",
      "u" => "u",
      "v" => "√",
      "w" => "w",
      "x" => "ﾒ",
      "y" => "ﾘ",
      "z" => "乙"
    }
  end

end
