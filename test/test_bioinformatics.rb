require 'helper'

class TestBioinformatics < Test::Unit::TestCase
  
  context "A Bioinformatics Network" do
    
    setup do
      @n = Network.new do
        attributes do
          title  "Bioinformatics"
          author "Kristopher J. Kosmatka"
          date    DateTime.now
        end
        
        variables do
          boolean :aaa
          boolean :bbb
          boolean :ccc
        end
        
        probabilities do
          aaa :probabilities => [0.1, 0.9]
          bbb :probabilities => [0.6, 0.4]
          ccc :given => [:aaa, :bbb] do
            [[1, 0],[1, 0],[1, 0],[0, 1]]
          end
        end
      end
    end
    
    should "do inference" do
      puts @n.ask :aaa
      puts @n.ask :bbb
      puts @n.ask :aaa, :given => { :ccc => true }
      puts @n.ask(:aaa) do
        given :bbb => true
      end
      puts @n.ask(:aaa) do
        given :bbb => true, :ccc => true
      end
    end
    
    
    
  end
end