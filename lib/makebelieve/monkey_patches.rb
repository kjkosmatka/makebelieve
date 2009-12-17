class Array
  
  alias_method :old_method_missing, :method_missing
  
  def random_item(number=1)
    if number == 1
      at(rand(length))
    else
      sort_by{rand}[0..number-1]
    end
  end
  
  def minima_on(method,*args)
    min_item = min { |a,b| a.send(method,*args) <=> b.send(method,*args) }
    find_all { |item| item.send(method,*args) == min_item.send(method,*args) }
  end
  
  def sum
    return inject(0) do |sum,item|
      if block_given?
        sum += yield item
      else
        sum += item
      end
    end
  end
  
  def multiply
    inject(1) do |product,item|
      if block_given?
        product *= yield item
      else
        product *= item
      end
    end
  end
  
  def normalized
    map { |i| i.to_f / sum }
  end
  
  def method_missing(symbol, *args, &block)
    if m = /^(find\w*)_by_(\w+)$/.match(symbol.to_s)
      find_method, attribute, value = m[1].to_sym, m[2].to_sym, args[0]
      send(find_method) { |item| item.send(attribute) == value }
    elsif m = /^(multiply|sum)_on_(\w+)$/.match(symbol.to_s)
      aggregator_method, attribute = m[1].to_sym, m[2].to_sym
      send(aggregator_method) { |item| item.send(attribute) } 
    elsif m = /^minima_on_(\w+)$/.match(symbol.to_s)
      method = m[1].to_sym
      minima_on(method,*args)
    else
      old_method_missing(symbol, *args, &block)
    end
  end
  
  def self.product(enumerables)
    #
  end
  
end

class Float
  def round_to(x)
    (self * 10**x).round.to_f / 10**x
  end

  def ceil_to(x)
    (self * 10**x).ceil.to_f / 10**x
  end

  def floor_to(x)
    (self * 10**x).floor.to_f / 10**x
  end
end

class DiscreteDistribution < Array
  def sample
    param_limit = 0
    random_sample = rand
    each_with_index do |param,i|
      param_limit += param
      return i if random_sample < param_limit
    end
  end
end

module Enumerable
  def each_combination
    collection = map { |item| Array(item) }
    counts = collection.map(&:size)
    ncombos = counts.inject(&:*)
    bases = counts.reverse.inject([1]) do |bases,count|
      bases << count * bases.last
    end
    bases.pop  
    bases.reverse!
    ncombos.times do |n|
      combo = n.change_base(bases).zip(collection).map do |idx,item|
        item[idx]
      end
      yield combo
    end
  end
end

class Integer
  def change_base(bases)
    nbr = self
    bases.inject([]) do |rebase,b|
      rebase << nbr / b
      nbr %= b
      rebase
    end
  end
end