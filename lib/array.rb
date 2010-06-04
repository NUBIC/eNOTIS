class Array
  def rand
    self[Kernel.rand(self.length)] 
  end
  def count_all(attribute, subattribute=nil)
    self.inject({}) do |hash, item|
      hash[item.send(attribute).to_s] ||= 0
      hash[item.send(attribute).to_s] += 1
      hash
    end.to_a.sort
  end
  def rotate(x=1)
    x.times{ push shift }
  end
end