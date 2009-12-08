class Potential
  
  def initialize(variables, probabilities)
    @vars = variables
    @probabilities = probabilities.flatten
  end
  
  def domain
    @vars.map { |v| v.name }
  end
  
  def probability(instance)
    return nil if not valid_instance?(instance)
    odometer = 1
    index = 0
    @vars.reverse.each do |v|
      outcome = instance[v.name]
      index += v.outcomes.index(outcome) * odometer
      odometer *= v.cardinality
    end
    @probabilities[index]
  end
  
  def valid_instance?(instance)
    return false unless Set.new(instance.keys) == Set.new(domain)
    @vars.each do |v|
      return false unless v.outcomes.include?(instance[v.name])
    end
    return true
  end
  
  def marginalize(variable_name)
    # TODO
  end
  
  def set_evidence(variable_setting)
    # TODO
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