require 'helper'

class TestVariable < Test::Unit::TestCase
  
  context "An array" do
    
    Person = Struct.new(:name, :color, :age)
    
    setup do
      @a = [Person.new('hugh','blue',34), Person.new('anne','yellow',12), Person.new('holly','orange',12)]
      @b = [1,2,3,4]
      @c = [0,1,2,3,4,5,6,7,8,9]
    end
    
    should "multiply attributes" do
      assert_equal 4896, @a.multiply_on_age
    end
    
    should "add attributes" do
      assert_equal 58, @a.sum_on_age
    end
    
    should "sum items using a block" do
      assert_equal 58, @a.sum { |p| p.age }
    end
    
    should "multiply items using a block" do
      assert_equal 4896, @a.multiply { |p| p.age }
    end
    
    should "sum plain old numerical arrays without a block" do
      assert_equal 10, @b.sum
    end
    
    should "find by attribute" do
      assert_equal 'hugh', @a.find_by_name('hugh').name
      assert_equal 2, @a.find_all_by_age(12).size
    end
    
    should "find minima based on attribute" do
      assert_equal 12, @a.minima_on(:age).first.age
      assert_equal 12, @a.minima_on_age.first.age
    end
    
    should "get random entries" do
      assert_equal 4, @c.random_item(4).size
    end
    
  end
  
  context "A discrete distribution" do
    setup do
      @d = DiscreteDistribution.new [0.1,0.3,0.6]
    end
    
    should "sample according to parameters" do
      counts = {0 => 0, 1 => 0, 2 => 0}
      n = 5000
      n.times do
        counts[@d.sample] += 1
      end
      # counts.each_pair { |k,v| puts "#{k}: #{v} ... #{v/n.to_f}" }
    end
  end
  
end