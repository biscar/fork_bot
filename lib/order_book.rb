class OrderBook

  attr_reader :asks, :bids, :reverse_calc

  def initialize(params = {})
    @asks = params[:asks]
    @bids = params[:bids]
    @reverse_calc = params.fetch(:reverse_calc, false)
  end

  def ask_top
    asks.first.try(&:first)
  end

  def bid_top
    bids.first.try(&:first)
  end

  def calc_ask(a, b)
    reverse_calc ? a*b : a/b
  end

  def calc_bid(a, b)
    reverse_calc ? a/b : a*b
  end

end