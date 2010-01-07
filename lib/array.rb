class Array
  def rand
    self[Kernel.rand(self.length)] 
  end
  def count_all(attribute, subattribute=nil)
    [[attribute.to_s, 'quantity']] + self.inject({}) do |hash, item|
      if item.send(attribute).is_a? Array
        item.send(attribute).each do |x|
          hash[x.send(subattribute).to_s] ||= 0
          hash[x.send(subattribute).to_s] += 1
        end
        hash
      else
        hash[item.send(attribute).to_s] ||= 0
        hash[item.send(attribute).to_s] += 1
        hash
      end
    end.to_a.sort
  end
end