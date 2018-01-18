class ForkFinder

  attr_reader :commission, :profit_percent, :exchanges_from, :exchanges_to, :limit, :pairs

  def initialize(params = {})
    @commission = params[:commission].to_f
    @profit_percent = params[:profit_percent]
    @exchanges_from = params[:exchanges_from].to_i
    @exchanges_to = params[:exchanges_to].to_i
    @limit = params[:limit].to_i
    @pairs = params[:pairs]
  end


  def find(ways)
    forks = []
    ways = exchanges_filter(ways)

    ways.each do |way|
      result, path_pairs = calc_way(way)

      if profit
        forks << Fork.new(way, result, path_pairs) if result >= profit
      else
        forks << Fork.new(way, result, path_pairs)
      end
    end

    forks.sort_by!{ |fork| fork.profit }.reverse!

    limit.zero? ? forks : forks.take(limit)
  end

  def recalc(way)
    result, path_pairs = calc_way(way)

    Fork.new(way, result, path_pairs)
  end

  private

  def calc_way(way)
    result = 1.0
    last_cur = nil
    path_pairs = []

    way.each do |cur|
      if last_cur && cur
        rate, pair = Rates.find_rate(pairs, last_cur, cur)
        path_pairs << pair

        result = (result*rate*fee).round(8)
      end

      last_cur = cur
    end

    [result, path_pairs]
  end

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