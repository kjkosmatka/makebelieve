require 'helper'

class TestPotential < Test::Unit::TestCase
  
  context "A potential" do
    
    setup do
      @u = Variable.new :smoking, [:none, :medium, :high]
      @v = Variable.new :bloop, [:one, :two, :three, :four]
      @w = Variable.new :cancer, [true, false]
      @p = Potential.new [@u,@v,@w], (1..24).to_a
    end
    
    should "report its domain." do
      assert_equal @p.domain, [:smoking, :bloop, :cancer]
    end
    
    should "access probabilities by full setting of variable outcomes." do
      assert_equal 1, @p.probability(:smoking => :none, :bloop => :one, :cancer => true)
      assert_equal 10, @p.probability(:smoking => :medium, :bloop => :one, :cancer => false)
    end
    
    should "return nil when queried with an invalid instance setting." do
      assert_nil @p.probability(:smoking => :nonny, :cancer => true)
    end
    
    should "identify valid instance settings." do
      assert @p.valid_instance?(:smoking => :none, :bloop => :three, 
                                :cancer => true, :variable => :not_in_domain)
    end
    
    should "identify invalid instance settings." do
      assert !@p.valid_instance?(:smoking => :invalid_outcome, 
                                 :bloop => :four, :cancer => true)
    end
    
    should "generate instances of an array of variables" do
      @p.instances_of([@u,@v])
    end
    
  end
  
  context "A marginalized potential" do
    setup do
      u = Variable.new :smoking, [:none, :medium, :high]
      v = Variable.new :bloop, [:one, :two, :three, :four]
      w = Variable.new :cancer, [true, false]
      @p = Potential.new [u,v,w], (1..24).to_a
      @p.marginalize! :bloop
    end
    
    should "be have the correct domain." do
      assert_equal @p.domain, [:smoking, :cancer]
    end
    
    should "access correct probabilities." do
      assert_equal 16, @p.probability(:smoking => :none, :cancer => true)
      assert_equal 84, @p.probability(:smoking => :high, :cancer => false)
    end
    
  end
  
  context "An observed potential" do
    setup do
      u = Variable.new :smoking, [:none, :medium, :high]
      v = Variable.new :bloop, [:one, :two, :three, :four]
      w = Variable.new :cancer, [true, false]
      @p = Potential.new [u,v,w], (1..24).to_a
      @p.observe! :bloop => :one
    end
    should "lose the observed variable" do
      assert_equal @p.domain, [:smoking, :cancer]
    end
    should "access correct probabilities" do
      assert_equal 1, @p.probability(:smoking => :none, :cancer => true)
      assert_equal 10, @p.probability(:smoking => :medium, :cancer => false)
    end
  end
  
end