class GibbsInference
  
  BURN_IN = 2000
  CHAIN_LENGTH = 2000
  
  attr_reader :current_instance
  
  def initialize(network, evidence, options={})
    defaults = { :burn_in => BURN_IN, :chain_length => CHAIN_LENGTH }
    options = defaults.merge(options)
    
    @network = network
    @evidence = evidence
    @burn_in = options[:burn_in]
    @chain_length = options[:chain_length]
    @current_instance = Variable::random_instantiation(@network.vars, :given => @evidence)
    @non_evidence_variables = @network.vars.collect(&:name).reject{ |v| evidence.keys.include?(v) }
    @tally = fresh_tally
  end
  
  def next_instance
    sample_var = @network.variable(@non_evidence_variables.random_item)
    other_settings = @current_instance.reject { |v,o| v == sample_var.name }
    dist = sample_var.instances.map do |inst|
      @network.full_setting_probability(other_settings.merge(inst))
    end
    dist = DiscreteDistribution.new(dist.normalized)
    # dist = @network.ask sample_var.name, :by => :enumeration, :given => other_settings
    @current_instance[sample_var.name] = sample_var.outcomes[dist.sample]
  end
  
  def burn_it_in
    @burn_in.times do
      # p @current_instance
      next_instance
    end
  end
  
  def fresh_tally
    tally = Hash.new
    @network.vars.each do |v|
      tally[v.name] = v.outcomes.map{0}
    end
    tally
  end
  
  def infer
    burn_it_in
    @tally = fresh_tally
    @chain_length.times do
      # p @tally
      # p @current_instance
      next_instance
      @current_instance.each_pair do |varname,outcome|
        @tally[varname][@network.variable(varname).outcomes.index(outcome)] += 1
      end
    end
  end
  
  def query(varname)
    DiscreteDistribution.new @tally[varname].normalized
  end
  
  
  
end