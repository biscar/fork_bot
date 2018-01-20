class Fork

  attr_reader :way, :profit, :pairs, :coins

  def initialize(params = {})
     @way = params[:way]
     @profit = params[:profit]
     @pairs = params[:pairs]
     @coins = params[:coins].to_f if params[:coins].present?
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
    (profit/(coins || 1) - 1).round(10)
  end

  def cycle?
    @cicle ||= way.first == way.last
  end

end