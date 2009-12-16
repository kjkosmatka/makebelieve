require 'helper'

class TestNetwork < Test::Unit::TestCase
  
  context "A Network" do
    
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
             [0.8,  0.2],  [0.05, 0.95]]
          end
        end 
      end
      @g = GibbsInference.new @n, :grass_wet => true
    end
    
    should "initialize a gibbs sampler" do
      GibbsInference.new @n, :grass_wet => true
    end
    
    should "give repeated instantiations drawn from conditional distributions" do
      50.times do
        # p @g.current_instance
        @g.next_instance
      end
    end
    
    should "infer" do
      @g.infer
      @n.vars.collect(&:name).each do |varname|
        by_enum = @n.ask varname, :given => {:grass_wet => true}
        p varname, @g.query(varname), by_enum
      end
    end
    
  end
  
end