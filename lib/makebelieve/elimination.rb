class Elimination
  
  attr_reader :pots, :graph, :query, :evidence, :order
  
  def initialize(network, query_variable, evidence, options={})
    @pots = network.pots.clone
    @graph = network.graph.clone
    @query = query_variable
    @evidence = evidence
    @order = options[:order]
  end
  
  def minimal_edge_inducers(options={:among => @graph.nodes})
    node_set = options[:among]
    min_node = node_set.min { |n,m| @graph.induced_edges(n) <=> @graph.induced_edges(m) }
    node_set.find_all { |n| @graph.induced_edges(n) == @graph.induced_edges(min_node) }
  end
  
  def minimal_potential_inducers(options={:among => @graph.nodes})
    node_set = options[:among]
    min_node = node_set.min { |n,m| induced_pot_size(n) <=> induced_pot_size(m) }
    node_set.find_all { |n| induced_pot_size(n) == induced_pot_size(min_node) }
  end
  
  def induced_pot_size(node)
    @pots.inject(Set.new) do |memo,pot|
      pot.domain.include?(node) ? memo | Set.new(pot.domain) : memo
    end.size
  end
  
  def eliminate(variable_name)
    relevant_pots = @pots.find_all { |pot| pot.domain.include?(variable_name) }
    newpot = relevant_pots.inject(&:*).clone
    if @evidence.keys.include?(variable_name)
      newpot.observe!( {variable_name => @evidence[variable_name]} )
    elsif variable_name != @query
      newpot.marginalize!(variable_name)
    end
    @pots.reject! { |pot| pot.domain.include?(variable_name) }
    @pots << newpot
    @graph.eliminate(variable_name)
  end
  
  def infer
    elim_nodes = @graph.nodes.reject { |n| n == @query }
    until elim_nodes.empty?
      min_e_nodes = minimal_edge_inducers :among => elim_nodes
      min_p_nodes = minimal_potential_inducers :among => min_e_nodes
      elim_node   = min_p_nodes.random_item
      eliminate          elim_node
      elim_nodes.delete  elim_node
    end
    final_pot = @pots.inject(&:*)
    final_pot.probabilities.normalized
  end
  
end