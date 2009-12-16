require 'helper'

class TestGraph < Test::Unit::TestCase
  context "A graph" do
    
    setup do
      @g = Graph.new do
        node :aaa
        node :bbb
        node :ccc
        breed [:aaa,:bbb], [:ccc]
      end
      @f = Graph.new
      @f.node :aaa
      @f.node :bbb
      @f.node :ccc
      @f.breed [:aaa,:bbb], [:ccc]
    end
    
    should "get parents of a node" do
      assert_equal [:aaa,:bbb], @g.parents(:ccc)
      assert_equal [:aaa,:bbb], @f.parents(:ccc)
    end
    
    should "get children of a node" do
      assert_equal [:ccc], @g.children(:aaa)
      assert_equal [:ccc], @f.children(:aaa)
    end
    
    should "get neighbors of a node" do
      assert_equal [:aaa,:bbb], @g.neighbors(:ccc)
      assert_equal [:aaa,:bbb], @f.neighbors(:ccc)
    end
    
    should "get number of induced edges on elimination of a node" do
      assert_equal 1, @g.induced_edges(:ccc)
      assert_equal 1, @f.induced_edges(:ccc)
    end
    
    should "eliminate a node adding induced edges to neighbors" do
      @g.eliminate(:ccc)
      @f.eliminate(:ccc)
    end
    
  end
  
end