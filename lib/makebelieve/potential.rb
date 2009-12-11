class Potential
  
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
    return false unless Set.new(instance.keys) == Set.new(domain)
    # every variable's setting in the instance must be valid
    not @variables.map { |v| v.outcomes.include?(instance[v.name]) }.include?(false)
  end
  
  def marginalize(variable,options={})
    mvariable = @variables.find { |v| v.name == variable }
    keepers = @variables.reject { |v| v.name == variable }
    outcomes = keepers.collect(&:outcomes)
    
    # cartesian product of outcomes across the keeper variables
    instances = outcomes.inject {|p,a| p.product(a)}.map(&:flatten)
    # converts the instances into hashes, keys are var names, vals are settings.
    instances = instances.map { |i| Hash[*keepers.collect(&:name).zip(i).flatten] }
    
    # for each instance in the keepers, sum across settings for the marginal var
    keeper_probs = instances.inject([]) do |margin, instance|
      margin << mvariable.outcomes.inject(0) do |sum, mvoutcome|
        instance[mvariable.name] = mvoutcome
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
    mvariable = @variables.find { |v| v.name == variable_setting.keys.first }
    keepers = @variables.reject { |v| v.name == variable_setting.keys.first }
    outcomes = keepers.collect(&:outcomes)
    instances = outcomes.inject {|p,a| p.product(a)}.map(&:flatten)
    instances = instances.map { |i| Hash[*keepers.collect(&:name).zip(i).flatten] }
    keeper_probs = instances.map do |i|
      probability(i.update(variable_setting))
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
    # TODO
  end
  
  def /(other)
    # TODO
  end
  
end