class String

  # Shamelessly stolen from Sugarcube
  def document_path
    @@textables_docs ||= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true)[0]
    return self if self.hasPrefix(@@textables_docs)

    @@textables_docs.stringByAppendingPathComponent(self)
  end

  # Shamelessly stolen from Sugarcube
  def resource_path
    @@textables_resources ||= NSBundle.mainBundle.resourcePath
    return self if self.hasPrefix(@@textables_resources)

    @@textables_resources.stringByAppendingPathComponent(self)
  end

  def file_exists?
    path = self.hasPrefix('/') ? self : self.document_path
    NSFileManager.defaultManager.fileExistsAtPath(path)
  end

  def remove_file!
    ptr = Pointer.new(:id)
    path = self.hasPrefix('/') ? self : self.document_path
    NSFileManager.defaultManager.removeItemAtPath(path, error:ptr)
    ptr[0]
  end

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
      '?' => '¿',
      ',' => '\'',
      '.' => '˙'
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
      'm' => 'M',
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
