require 'helper'

class TestNetwork < Test::Unit::TestCase
  
  context "A Network" do
    
    setup do
      @n = Network.new do
        attributes do
          title  "Earthquakes and Burglaries"
          author "Kristopher J. Kosmatka"
          date    DateTime.now
        end

        variables do
          boolean  :alarm
          boolean  :neighbor_call
          boolean  :burglary
          discrete :earthquake, [:none, :medium, :large]
        end

        probabilities do
          alarm :given => [:burglary, :earthquake] do
            [[0.5, 0.5], [0.5, 0.3], [0.5, 0.5],
             [0.5, 0.5], [0.5, 0.5], [0.5, 0.5]]
          end
          neighbor_call :given => :alarm do
            [[0.9, 0.1],
             [0.8, 0.2]]
          end
          burglary   :probabilities => [0.1, 0.9]
          earthquake :probabilities => [0.01, 0.09, 0.9]
        end
        
      end
    end
    
    should "allow dynamic metainfo setting" do
      assert_equal "Earthquakes and Burglaries", @n.meta.title
      assert_equal "Kristopher J. Kosmatka", @n.meta.author
      puts @n.meta.date
    end
    
    should "allow adding variables in the instantiation block" do
      assert_equal 4, @n.vars.size
      assert_equal :alarm, @n.vars.first.name
      assert_equal [true,false], @n.vars.first.outcomes
      assert_equal [:none,:medium,:large], @n.vars.last.outcomes
    end
    
    should "allow adding potentials in the instantiation block" do
      assert_equal 4, @n.pots.count
      assert_equal [:burglary, :earthquake, :alarm], @n.pots.first.domain
      assert_equal [:alarm, :neighbor_call], @n.pots[1].domain
      assert_equal [:earthquake], @n.pots[3].domain
      assert_equal 0.3, @n.pots.first.probability(
        :alarm => false, :earthquake => :medium, :burglary => true)
    end
    
    should "allow products of its potentials" do
      @n.pots.first * @n.pots.last
    end
    
  end

end