class OrderBook

  attr_reader :asks, :bids, :commission

  def initialize(params = {})
    @asks = params[:asks]
    @bids = params[:bids]
    @commission = params[:commission].to_f
  end

  def ask_top
    asks.first.try(&:first)
  end

  def bid_top
    bids.first.try(&:first)
  end

  def calc_bid_by_coins(coins)
    rest = coins.dup
    total_coins = 0

    bids.each do |cost, total_from|
      cost = cost.to_f
      total_from = total_from.to_f

      if total_from >= rest
        total_coins += (rest*cost*fee).round(8)
        rest = 0
      else
        total_coins += (total_from*cost*fee).round(8)
        rest = rest - total_from
      end

      break if rest == 0
    end

    rest == 0 ? total_coins : nil
  end

  def calc_ask_by_coins(coins)
    rest = coins.dup
    total_coins = 0

    asks.each do |cost, total_from, _|
      cost = cost.to_f
      total_from = total_from.to_f

      if total_from >= rest
        total_coins += ((rest/cost)*fee).round(8)
        rest = 0
      else
        total_coins += ((total_from/cost)*fee).round(8)
        rest = rest - total_from
      end

      break if rest == 0
    end

    rest == 0 ? total_coins : nil
  end

  def fee
    @fee ||= (100 - commission)/100
  end

end