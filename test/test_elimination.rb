require 'helper'

class TestElimination < Test::Unit::TestCase
  
  context "A network and an elimination" do
    
    setup do
      
      @n = Network.new do
        attributes do
          title  "Wet Grass"
          author "Kristopher J. Kosmatka"
          date    DateTime.now
        end

        variables do
          boolean  :god
          boolean  :rain
          boolean  :sprinkler
          boolean  :grass_wet
        end

        probabilities do
          god :distribution => [0.01, 0.99]
          rain :given => :god do
            [[0.2, 0.8], [0.5, 0.5]]
          end
          sprinkler :given => :rain do
            [[0.01, 0.99], [0.4, 0.6]]
          end
          grass_wet :given => [:sprinkler, :rain] do
            [[0.99, 0.01], [0.9, 0.1],
             [0.8,  0.2],  [0.0, 1.0]]
          end
        end 
      end
      
      @e = Elimination.new(@n, :rain, {:sprinkler => true})
      
    end
    
    should "initialize an elimination" do
      assert_nothing_raised do
        Elimination.new(@n, :rain, {:sprinkler => true})
      end
    end
    
    should "find nodes that induce minimal edges" do
      assert_equal [:god, :sprinkler], 
        @e.minimal_edge_inducers(:among => [:god, :sprinkler, :rain])
    end
    
    should "find nodes that induce minimal potentials" do
      assert_equal [:god], @e.minimal_potential_inducers
    end
    
    should "infer" do
      assert_equal [0.024, 0.976], @e.infer.map { |p| p.round_to(3) }
    end
    
  end

end