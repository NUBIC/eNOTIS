class Array
  def rand
    self[Kernel.rand(self.length)] 
  end
  def count_all(*attributes)
    result = {}
    attributes.map do |attribute|
      result[attribute] = self.inject({}) do |hash, item|
        hash[item[attribute].to_s.to_sym] ||= 0
        hash[item[attribute].to_s.to_sym] += 1
        hash
      end
    end
    result
  end
end