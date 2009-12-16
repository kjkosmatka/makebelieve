class Variable
  
  attr_reader :name, :outcomes
  
  def initialize(name,outcomes)
    @name, @outcomes = name, outcomes
    @parents, @children = [], []
  end
  
  def cardinality
    @outcomes.size
  end
  
  def instances
    outcomes.map { |o| {name => o} }
  end

  def self.instantiations(variables, options={})
    defaults = {:given => {}}
    options = defaults.merge(options)
    evidence = options[:given]
    if variables.size < 2
      return variables.first.instances.reject { |i| i != i.merge(evidence) }
    else
      inst = variables.collect(&:instances).inject(&:product).map(&:flatten)
      inst = inst.map{ |i| i.inject(&:merge) }
      return inst.reject { |i| i != i.merge(evidence) }
    end
  end
  
  def self.each_instantiation(variables, options={})
    self.instantiations(variables, options).each do |instantiation|
      yield instantiation
    end
  end
  
end