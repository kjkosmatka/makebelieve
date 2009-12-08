require 'helper'
require 'set'

class TestPotential < Test::Unit::TestCase
  
  context "A potential" do
    
    setup do
      u = Variable.new :smoking, [:none, :medium, :high]
      v = Variable.new :cancer, [true, false]
      @p = Potential.new [u,v], [[0.1, 0.9],
                                 [0.3, 0.7],
                                 [0.9, 0.1]]
    end
    
    should "report its domain." do
      assert_equal @p.domain, [:smoking, :cancer]
    end
    
    should "access probabilities by full setting of variable outcomes." do
      assert_equal 0.1, @p.probability(:smoking => :none, :cancer => true)
      assert_equal 0.7, @p.probability(:cancer => false, :smoking => :medium)
    end
    
    should "return nil when queried with an invalid instance setting." do
      assert_nil @p.probability(:smoking => :nonny, :cancer => true)
    end
    
    should "identify valid instance settings." do
      assert @p.valid_instance?(:smoking => :none, :cancer => true)
    end
    
    should "identify invalid instance settings." do
      assert !@p.valid_instance?(:smoking => :noone, :cancer => true)
    end
    
  end
  
end