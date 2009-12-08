class Variable
  
  attr_reader :name, :outcomes, :cardinality
  
  def initialize(name,outcomes)
    @name, @outcomes = name, outcomes
    @cardinality = outcomes.size
  end
  
end