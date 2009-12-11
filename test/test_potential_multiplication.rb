require 'helper'

class TestPotential < Test::Unit::TestCase
  
  context "A product of potentials" do
    
    setup do
      u = Variable.new :smoking, [:none, :medium, :high]
      v = Variable.new :bloop, [:one, :two, :three, :four]
      w = Variable.new :cancer, [true, false]
      
      @p = Potential.new [u,v], (1..12).to_a
      @q = Potential.new [v,w], (1..8).to_a
      @r = @p * @q
    end
    
    should "multply without failure." do
      assert_nothing_raised do
        @p * @q
      end
    end
    
    should "have the correct domain" do
      assert_equal Set.new([:smoking, :bloop, :cancer]), Set.new(@r.domain)
    end
    
    should "have correct products in the table" do
      inst1 = {:smoking => :none, :bloop => :one, :cancer => true}
      inst2 = {:smoking => :none, :bloop => :three, :cancer => false}
      assert_equal 1, @r.probability(inst1)
      assert_equal 6*3 , @r.probability(inst2)
    end
  
  end

end