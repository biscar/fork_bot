class ForkFinder

  class << self

    def find(curs, pairs, selected_cur)
      forks = []

      puts selected_cur

      g = Graph.new(curs, pairs)
      paths = g.cicles_paths(selected_cur)

      puts "Pathes were found #{paths.count}"

      paths.each do |path|
        result = 1.to_f;
        #str = "#{selected_cur}->" + path.map(&:name).join('->')
        last_cur = nil
        path.unshift(selected_cur)
        path_pairs = []
        path.each do |cur|
          if last_cur && cur
            rate, pair = Rates.find_rate(pairs, last_cur, cur)
            path_pairs << pair

            result = result*rate

            result = result - result*0.002
          end

          last_cur = cur
        end

        #puts "#{str}:#{result.round(5)}" if result > 1.0

        forks << Fork.new(path, result, path_pairs) if result > 1.04
      end


      forks.sort_by{ |fork| [fork.length, fork.profit] }.each do |fork|

        puts fork
        puts fork.pairs_ask_bid
      end

      puts "Forks #{forks.count}"

      nil
    end

  end



end