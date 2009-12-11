class Network
  
  require 'ostruct'
  CONTEXTS = [:variables, :probabilities, :attributes]
  attr_reader :vars, :pots, :meta
  
  def initialize(options={}, &block)
    @meta = OpenStruct.new
    @vars = options[:variables].nil? ? [] : optioens[:variables]
    @pots = options[:potentials].nil? ? [] : options[:potentials]
    self.instance_eval(&block) if block_given?
  end
  
  def boolean(name)
    @vars << Variable.new(name,[true,false])
  end
  
  def discrete(name,outcomes)
    @vars << Variable.new(name,outcomes)
  end
  
  def new_potential(variable_name, options={}, &block)
    varnames = Array(options[:given]) + Array(variable_name)
    vars = varnames.map do |vname|
      @vars.find { |v| v.name == vname }
    end
    probs = options[:probabilities]
    probs = block.call if block_given?
    @pots << Potential.new(vars, probs)
  end
  
  def context(symbol, &block)
    @context = symbol.to_sym
    if block_given? and CONTEXTS.include?(@context)
      self.instance_eval(&block)
    end
    @context = nil
  end
  
  def method_missing(symbol, *args, &block)
    if CONTEXTS.include?(symbol)
      context(symbol, &block)
    elsif @context == :variables
      # pass
    elsif @context == :probabilities
      new_potential(symbol, *args, &block)
    elsif @context == :attributes
      @meta.send("#{symbol}=", args[0])
    else
      raise NoMethodError
    end
  end
  
end