require 'helper'

class TestVariable < Test::Unit::TestCase
  context "A variable" do
    
    setup do
      @u = Variable.new :rain, [true, false]
      @v = Variable.new :smoking, [:none, :medium, :high]
      @w = Variable.new :fever, [:none, :mild, :severe]
    end
    
    should "know its name." do
      assert_equal :smoking, @v.name
    end
    
    should "have an ordered list of outcomes." do
      assert_equal [:none, :medium, :high], @v.outcomes
    end
    
    should "report its instances" do
      assert_equal [{:rain => true},{:rain => false}], @u.instances
    end
    
    should "report its cardinality." do
      assert_equal @v.cardinality, 3
    end
    
    should "iterate through instances" do
      vars = [@u, @v, @w]
      evidence = { :smoking => :high, :rain => true }
      assert_nothing_raised do
        Variable::each_instantiation(vars, :given => evidence) do |inst|
          # pass
        end
      end
    end
        
    should "return an array of instances of variable consistent with evidence" do
      vars = [@u, @v, @w]
      evidence = { :smoking => :high, :rain => true }
      assert_equal 3, Variable::instantiations(vars, :given => evidence).size
    end
    
  end
  
end
