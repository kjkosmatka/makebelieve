class Potential
  
  require 'set'
  
  attr_reader :variables, :probabilities
  
  def initialize(variables, probabilities)
    @variables = variables
    @probabilities = probabilities.flatten
    validate_table_size
  end
  
  def validate_table_size
    n = @variables.inject(1) { |product,variable| product *= variable.cardinality }
    unless @probabilities.size == n
      raise(ArgumentError,'Variable cardinalities and CPT size do not agree')
    end
  end
  
  def domain
    @variables.collect(&:name)
  end
  
  def probability(instance)
    return nil unless valid_instance?(instance)
    odometer, index = 1, 0
    @variables.reverse.each do |v|
      outcome = instance[v.name]
      index += v.outcomes.index(outcome) * odometer
      odometer *= v.cardinality
    end
    @probabilities[index]
  end
  
  def valid_instance?(instance)
    # the instance must have a setting for every variable
    instance_domain, potential_domain = Set.new(instance.keys), Set.new(domain)
    return false unless potential_domain.subset? instance_domain
    
    # every variable's setting in the instance must be valid
    @variables.all? { |v| v.outcomes.include?(instance[v.name]) }
  end
  
  def marginalize(variable_name,options={})
    marginal_var = @variables.find { |v| v.name == variable_name }
    keepers = @variables.reject { |v| v.name == variable_name }
    
    keeper_probs = Variable::instantiations(keepers).map do |instance|
      marginal_var.instances.inject(0) do |sum,marginal_instance|
        sum + probability(instance.merge(marginal_instance))
      end
    end
    if options[:mutate]
      @variables, @probabilities = keepers, keeper_probs
      return self
    else
      Potential.new(keepers, keeper_probs)
    end
  end
  
  def marginalize!(variable_name)
    marginalize(variable_name, :mutate => true)
  end
  
  def observe(evidence,options={})
    keepers = @variables.reject { |v| evidence.keys.include?(v.name) }
    keeper_probs = Variable::instantiations(keepers).map do |instance|
      probability(instance.merge(evidence))
    end
    if options[:mutate]
      @variables, @probabilities = keepers, keeper_probs
    else
      Potential.new(keepers, keeper_probs)
    end
  end
  
  def observe!(evidence)
    observe(evidence, :mutate => true)
  end
  
  def normalize
    # TODO
  end
  
  def *(other)
    vars = Set.new(@variables + other.variables).to_a
    probs = Variable::instantiations(vars).map do |instance|
      probability(instance) * other.probability(instance)
    end
    Potential.new(vars,probs)
  end
  
  def /(other)
    # TODO
  end
  
  def another
    Potential.new(@variables.map(&:dup),@probabilities.dup)
  end
  
end