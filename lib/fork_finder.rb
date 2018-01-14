class ForkFinder

  class << self

    def find(curs, pairs, selected_cur, params = {})
      profit = 1 + (params[:profit].to_f)/100.to_f if params[:profit].present?

      forks = []
      g = Graph.new(curs, pairs)
      paths = g.cicles_paths(selected_cur)

     # puts "Pathes were found #{paths.count}"

      paths.each do |path|
        result = 1.to_f;
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

        if profit
          forks << Fork.new(path, result, path_pairs) if result > profit
        else
          forks << Fork.new(path, result, path_pairs)
        end
      end


      forks.sort_by!{ |fork| [fork.length, fork.profit] }

      #puts "Forks #{forks.count}"

      forks
    end

  end



end