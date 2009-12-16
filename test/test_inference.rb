require 'helper'

class TestInference < Test::Unit::TestCase
  
  context "A Network" do
    
    setup do
      @n = Network.new do
        attributes do
          title  "Wet Grass"
          author "Kristopher J. Kosmatka"
          date    DateTime.now
        end

        variables do
          boolean  :cloudy
          boolean  :sprinkler
          boolean  :rain
          boolean  :wet_grass
        end

        probabilities do
          cloudy :probabilities => [0.5, 0.5]
          sprinkler :given => :cloudy do
            [[0.1, 0.9], [0.5, 0.5]]
          end
          rain :given => :cloudy do
            [[0.8, 0.2], [0.2, 0.8]]
          end
          wet_grass :given => [:sprinkler, :rain] do
            [[0.99, 0.01], [0.9, 0.1], [0.9, 0.1], [0.0, 1.0]]
          end
        end
      end
    end
    
    should "get correct cpt settings" do
      assert_equal 0.2, @n.pots[2].probability(:rain => true, :cloudy => false)
    end
    
    should "give correct inference" do
      d = @n.ask :sprinkler do
        given :wet_grass => true
      end
      assert_equal 0.430, d[0].round_to(3)
      d = @n.ask :rain do
        given :wet_grass => true
      end
      assert_equal 0.708, d[0].round_to(3)
    end
    
  end
end