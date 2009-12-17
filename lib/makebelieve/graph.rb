class Graph
  
  require 'set'
  
  Edge = Struct.new(:parent,:child)
  
  attr_accessor :nodes, :edges
  
  def initialize(nodes=nil, edges=nil, &block)
    @nodes = nodes.nil? ? [] : nodes
    @edges = edges.nil? ? [] : edges
    instance_eval(&block) if block_given?
  end
  
  def node(symbol)
    @nodes << symbol unless @nodes.include?(symbol)
  end
  
  def breed(parents,children)
    Array(parents).each do |parent|
      Array(children).each do |child|
        e = Edge.new(parent,child)
        @edges << e unless @edges.include?(e)
      end
    end
  end
  
  def children(node)
    @edges.find_all_by_parent(node).collect(&:child)
  end
  
  def parents(node)
    @edges.find_all_by_child(node).collect(&:parent)
  end
  
  def neighbors(node)
    (Set.new(children(node)) | Set.new(parents(node))).to_a
  end
  
  def adjacent(a,b)
    @edges.include?(Edge.new(a,b)) or @edges.include?(Edge.new(b,a))
  end
  
  def neighbor_pairs(node)
    ns = neighbors(node)
    ns.product(ns).reject { |pair| pair[0] == pair[1] }
  end
  
  def induced_edges(node)
    neighbor_pairs(node).sum do |pair|
      adjacent(*pair) ? 0 : 0.5
    end
  end
  
  def eliminate(node)
    neighbor_pairs(node).each do |pair|
      breed(*pair) unless adjacent(*pair)
    end
    remove(node)
  end
  
  def remove(node)
    @edges.reject! { |e| e.parent == node or e.child == node }
    @nodes.reject! { |n| n == node }
  end
  
  def another
    Graph.new(@nodes.dup,@edges.dup)
  end
  
end