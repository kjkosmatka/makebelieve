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
          boolean  :rain
          boolean  :sprinkler
          boolean  :grass_wet
        end

        probabilities do
          rain :distribution => [0.2, 0.8]
          sprinkler :given => :rain do
            [[0.01, 0.99], [0.4, 0.6]]
          end
          grass_wet :given => [:sprinkler, :rain] do
            [[0.99, 0.01], [0.9, 0.1],
             [0.8,  0.2],  [0.0, 1.0]]
          end
        end
        
      end
    end
    
    should "allow dynamic metainfo setting" do
      assert_equal "Wet Grass", @n.meta.title
      assert_equal "Kristopher J. Kosmatka", @n.meta.author
    end
    
    should "allow adding variables in the instantiation block" do
      assert_equal 3, @n.vars.size
      assert_equal :rain, @n.vars.first.name
      assert_equal [true,false], @n.vars.first.outcomes
      assert_equal [true,false], @n.vars.last.outcomes
    end
    
    should "allow adding potentials in the instantiation block" do
      assert_equal 3, @n.pots.count
      assert_equal [:rain], @n.pots.first.domain
      assert_equal [:rain, :sprinkler], @n.pots[1].domain
    end
    
    should "allow products of its potentials" do
      @n.pots.first * @n.pots.last
    end
    
    should "return a distribution when queried using enumeration" do
      dist = @n.ask :rain, :by => :enumeration do
        given :grass_wet => true
      end
      assert_equal [0.3577, 0.6423], dist.map { |i| i.round_to(4) }
    end
    
    should "return a distribution when queried using elimination" do
      dist = @n.ask :rain, :by => :elimination do
        given :grass_wet => true
      end
      assert_equal [0.3577, 0.6423], dist.map { |i| i.round_to(4) }
    end
    
    should "return a distribution when queried using gibbs sampling" do
      dist = @n.ask :rain, :by => :gibbs do
        given :grass_wet => true
      end
      # p "by gibbs #{dist.inspect}"
    end
    
    should "have a graph representation" do
      assert_equal [:rain, :sprinkler, :grass_wet], @n.graph.nodes
    end
    
    should "compute a full setting" do
      # p @n.full_setting_probability(:rain => true, :sprinkler => true, :grass_wet => true )
      # p @n.full_setting_probability(:rain => false, :sprinkler => false, :grass_wet => false )
    end
    
  end

end