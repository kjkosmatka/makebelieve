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
    map { |i| i / sum }
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