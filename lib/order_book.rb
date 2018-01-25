class OrderBook

  attr_reader :asks, :bids

  def initialize(params = {})
    @asks = params[:asks]
    @bids = params[:bids]
  end

  def ask_top
    asks.first.try(&:first)
  end

  def bid_top
    bids.first.try(&:first)
  end

end