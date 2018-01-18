require 'best_way'
require 'rgl/bellman_ford'
require 'rgl/adjacency'
require 'rgl/dijkstra'
require 'rgl/dot'
require 'rgl/edmonds_karp'
require 'rgl/bipartite'


class Graph

  attr_reader :graph, :pairs, :curs

  def initialize(curs=[], pairs=[])
    @curs = curs
    @pairs = pairs
    @graph = RGL::AdjacencyGraph.new

    nodes = @pairs.map { |pair| [pair.numerator, pair.denominator] }
    nodes.each do |(src, target)|
      @graph.add_edge(src, target)
    end

  end

  def ways(start_currency, finish_currency = start_currency)
    if start_currency == finish_currency
      ways = graph.cycles_with_vertex(start_currency)
      ways.each { |w| w.unshift(start_currency)}
      ways
    else
      graph.best_ways(start_currency, finish_currency)
    end
  end

end