module RGL
  module MutableGraph

    def best_ways(start, finish)
      cycles_with_vertex_helper(finish, start, [start])
    end

  end

end
