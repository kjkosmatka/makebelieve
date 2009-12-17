class Variable
  
  attr_accessor :name, :outcomes
  
  def initialize(name,outcomes)
    @name, @outcomes = name, outcomes
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
  
  def self.each_instantiation(variables, options={:given => {}})
    evidence = options[:given]
    non_e_vars = variables.reject { |v| evidence.keys.include?(v.name) }
    non_e_names = non_e_vars.collect(&:name)
    non_e_outcomes = non_e_vars.collect(&:outcomes)
    non_e_outcomes.each_combination do |outcome_combo|
      non_evidence = Hash[*non_e_names.zip(outcome_combo).flatten]
      yield evidence.merge(non_evidence)
    end
  end
  
  def self.random_instantiation(variables, options={:given => {}})
    evidence = options[:given]
    inst = {}
    variables.each do |v|
      if evidence.has_key?(v.name)
        inst[v.name] = evidence[v.name]
      else
        inst[v.name] = v.outcomes.random_item
      end
    end
    return inst
  end
  
end