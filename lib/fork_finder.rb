class ForkFinder

  class << self

    def find(curs, pairs, selected_cur, params = {})
      forks = []
      profit = 1 + (params[:profit].to_f)/100.to_f if params[:profit].present?
      g = Graph.new(curs, pairs)
      paths = exchanges_filter(g.cicles_paths(selected_cur),
                               params[:exchanges_from].to_i,
                               params[:exchanges_to].to_i)

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

            result = result*rate*0.998
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

    private

    def exchanges_filter(paths, from, to)
      return paths if from.zero? && to.zero?

      paths.select do |ways|
        if !from.zero? && !to.zero?
          from <= ways.count && ways.count <= to
        elsif !from.zero?
          from <= ways.count
        elsif !to.zero?
          ways.count <= to
        end
      end
    end
  end
end