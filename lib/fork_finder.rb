class ForkFinder

  attr_reader :commission, :profit_percent, :exchanges_from, :exchanges_to

  def initialize(params = {})
    @commission = params[:commission].to_f
    @profit_percent = params[:profit_percent]
    @exchanges_from = params[:exchanges_from].to_i
    @exchanges_to = params[:exchanges_to].to_i
  end


  def find(paths, pairs, selected_cur)
    forks = []
    paths = exchanges_filter(paths)

    paths.each do |path|
      result = 1.to_f
      last_cur = nil
      path.unshift(selected_cur)
      path_pairs = []
      path.each do |cur|
        if last_cur && cur
          rate, pair = Rates.find_rate(pairs, last_cur, cur)
          path_pairs << pair

          result = result*rate*fee
        end

        last_cur = cur
      end

      if profit
        forks << Fork.new(path, result, path_pairs) if result >= profit
      else
        forks << Fork.new(path, result, path_pairs)
      end
    end

    forks.sort_by!{ |fork| fork.profit }.reverse!

    forks
  end

  def recalc(path, pairs)
    result = 1.to_f
    last_cur = nil
    path_pairs = []

    path.each do |cur|
      if last_cur && cur
        rate, pair = Rates.find_rate(pairs, last_cur, cur)
        path_pairs << pair

        result = result*rate*fee
      end

      last_cur = cur
    end

    Fork.new(path, result, path_pairs)
  end

  private

  def exchanges_filter(paths)
    return paths if exchanges_from.zero? && exchanges_to.zero?

    paths.select do |ways|
      if !exchanges_from.zero? && !exchanges_to.zero?
        exchanges_from <= ways.count && ways.count <= exchanges_to
      elsif !exchanges_from.zero?
        exchanges_from <= ways.count
      elsif !exchanges_to.zero?
        ways.count <= exchanges_to
      end
    end
  end

  def fee
    @fee ||= (100 - commission)/100
  end

  def profit
    @profit ||= (
     1 + (profit_percent.to_f)/100.to_f
    ) if profit_percent.present?
  end


end