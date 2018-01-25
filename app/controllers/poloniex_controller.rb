class PoloniexController < ForkController

  def index
    @currencies = Currency.parse_to_currencies(currencies)
    @pairs = Pair.parse_to_pairs(Poloniex.ticker.keys, @currencies)
  end

  private

  def currencies
    Poloniex.ticker.keys.map { |pair| Pair.split(pair) }.flatten.uniq
  end

end
