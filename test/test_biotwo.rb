require 'helper'

class TestBiotwo < Test::Unit::TestCase
  
  context "A Bioinformatics Network" do
    
    setup do
      @n = Network.new do
        attributes do
          title  "Bioinformatics II"
          author "Kristopher J. Kosmatka"
          date    DateTime.now
        end
        
        variables do
          boolean :aaa
          boolean :bbb
          boolean :ccc
          boolean :ddd
        end
        
        probabilities do
          aaa :probabilities => [0.4, 0.6]
          bbb :given => :aaa do
            [[0.5,0.5],[0.2,0.8]]
          end
          ccc :given => :bbb do
            [[0.7, 0.3],[0.9, 0.1]]
          end
          ddd :given => [:aaa, :ccc] do
            [[0.9,0.1],[0.3,0.7],[0.4,0.6],[0.1,0.9]]
          end
        end
      end
    end
    
    should "do inference" do
      puts @n.ask :bbb, :given => { :ddd => true }
    end
    
    
    
  end
end