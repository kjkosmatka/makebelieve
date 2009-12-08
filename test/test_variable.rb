require 'helper'

class TestVariable < Test::Unit::TestCase
  context "A variable" do
    
    setup do
      @v = Variable.new :smoking, [:none, :medium, :high]
    end
    
    should "know its name." do
      assert_equal @v.name, :smoking
    end
    
    should "have an ordered list of outcomes." do
      assert_equal @v.outcomes, [:none, :medium, :high]
    end
    
    should "report its cardinality." do
      assert_equal @v.cardinality, 3
    end
    
  end
  
end
