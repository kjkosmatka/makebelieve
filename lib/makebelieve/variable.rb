class Variable
  
  attr_reader :name, :outcomes
  
  def initialize(name,outcomes)
    @name, @outcomes = name, outcomes
  end
  
  def cardinality
    @outcomes.size
  end
  
end