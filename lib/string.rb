require 'iconv'
class String
  def force_utf8
    ::Iconv.conv('UTF-8//IGNORE', 'UTF-8', self + ' ')[0..-2]
  end
end
