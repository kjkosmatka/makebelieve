class Network
  
  require 'ostruct'
  CONTEXTS = [:variables, :probabilities, :attributes]
  attr_reader :vars, :pots, :meta, :graph
  
  def initialize(options={}, &block)
    @meta = OpenStruct.new
    @graph = Graph.new
    @vars = options[:variables].nil? ? [] : optioens[:variables]
    @pots = options[:potentials].nil? ? [] : options[:potentials]
    self.instance_eval(&block) if block_given?
  end
  
  def ask(variable_name, options={}, &block)
    defaults = {:by => :enumeration, :given => Hash.new}
    options = defaults.merge(options)
    var = @vars.find_by_name(variable_name)
    evidence = block_given? ? instance_eval(&block) : options[:given]
    if options[:by] == :enumeration
      return ask_enumerate(var, evidence)
    elsif options[:by] == :elimination
      return Elimination.new(self,variable_name,evidence).infer
    elsif options[:by] == :gibbs
      g = GibbsInference.new(self, evidence)
      g.infer
      return g.query(variable_name)
    end
  end
  
  def ask_enumerate(variable, evidence)
    # form an array with an entry for each outcome of the query variable
    distribution = variable.outcomes.map do |voutcome|
      # add this outcome to the evidence
      ev = evidence.merge({variable.name => voutcome})
      # summing across all instantiations consistent with evidence
      Variable::instantiations(@vars, :given => ev).sum do |instance|
        @pots.multiply { |pot| pot.probability(instance) }
      end
    end
    DiscreteDistribution.new distribution.normalized
  end
  
  def given(evidence)
    evidence
  end
  
  def discrete(name, outcomes=[true,false])
    @vars << Variable.new(name,outcomes)
  end
  
  alias_method :boolean, :discrete
  
  def add_potential(variable_name, options={}, &block)
    parents = options[:given]
    @graph.node variable_name
    @graph.breed parents, variable_name unless parents.nil?
    
    varnames = Array(options[:given]) + Array(variable_name)
    vars = varnames.map { |vname| @vars.find_by_name(vname) }
    probs = block_given? ? block.call : options[:distribution]
    @pots << Potential.new(vars, probs)
  end
  
  def variable(symbol)
    @vars.find_by_name(symbol)
  end
  
  def context(symbol, &block)
    @context = symbol.to_sym
    instance_eval(&block) if block_given? and CONTEXTS.include?(@context)
    @context = nil
  end
  
  def method_missing(symbol, *args, &block)
    if CONTEXTS.include?(symbol)
      context(symbol, &block)
    elsif @context == :variables
      # pass
    elsif @context == :probabilities
      add_potential(symbol, *args, &block)
    elsif @context == :attributes
      @meta.send("#{symbol}=", args[0])
    else
      raise NoMethodError
    end
  end
  
end