class String

  def sanitize

    name = self.to_ascii
    name = name.gsub(/[^a-zA-Z0-9\.\-\+_]/, "_")

    name = "_#{name}" if name =~ /\A\.+\z/
    name = "unnamed" if name.size == 0
    return name.mb_chars.to_s
  end

end

class Nil

  def sanitize_file_name;  nil;  end

end
