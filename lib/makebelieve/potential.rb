class Potential
  
  require 'set'
  
  attr_reader :variables
  
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
    @variables.map { |v| v.name }
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
    not @variables.map { |v| v.outcomes.include?(instance[v.name]) }.include?(false)
  end
  
  def instances_of(variables)
    names = variables.collect(&:name)
    outcomes = variables.collect(&:outcomes)
    outcomes.inject { |p,a| p.product(a) }.map(&:flatten).map do |instance|
      Hash[*names.zip(instance).flatten]
    end
  end
  
  def marginalize(variable,options={})
    mvar = @variables.find { |v| v.name == variable }
    keepers = @variables.reject { |v| v.name == variable }
    keeper_probs = instances_of(keepers).map do |instance|
      mvar.outcomes.inject(0) do |sum, mvoutcome|
        instance[mvar.name] = mvoutcome
        sum += probability(instance)
      end
    end
    if options[:mutate]
      @variables, @probabilities = keepers, keeper_probs
    else
      Potential.new(keepers, keeper_probs)
    end
  end
  
  def marginalize!(variable)
    marginalize(variable, :mutate => true)
  end
  
  def observe(variable_setting,options={})
    keepers = @variables.reject { |v| v.name == variable_setting.keys.first }
    keeper_probs = instances_of(keepers).map do |instance|
      probability(instance.update(variable_setting))
    end
    if options[:mutate]
      @variables, @probabilities = keepers, keeper_probs
    else
      Potential.new(keepers, keeper_probs)
    end
  end
  
  def observe!(variable_setting)
    observe(variable_setting, :mutate => true)
  end
  
  def normalize
    # TODO
  end
  
  def *(other)
    vars = Set.new(@variables + other.variables).to_a
    probs = instances_of(vars).map do |instance|
      probability(instance) * other.probability(instance)
    end
    Potential.new(vars,probs)
  end
  
  def /(other)
    # TODO
  end
  
end