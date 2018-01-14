class Fork

  attr_reader :way, :profit, :pairs

  def initialize(way, profit, pairs)
     @way = way
     @profit = profit
     @pairs = pairs
  end

  def length
    way.count
  end

  def pairs_ask_bid
    pairs.map { |pair| "#{pair.to_s}(#{pair.ask_top}/ #{pair.bid_top})" }.join('->')
  end

  def details
    pairs.map do |pair|
      {name: pair.to_s, ask: pair.ask, bid: pair.bid}
    end
  end

  def to_s
    "#{way.join('->')}"
  end

  def percentage_profit
    ((profit - 1) * 100).round(2)
  end

end