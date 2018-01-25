class PoloniexController < ForkController

  def index
    @currencies = Currency.parse_to_currencies(currencies)
    @pairs = Pair.parse_to_pairs(Poloniex.ticker.keys, @currencies)
  end


  def find_forks
    selected_pairs = params[:pairs]

    currencies = Currency.parse_to_currencies(params[:currencies])
    start_currency = Currency.find_selected_cur(currencies, params[:start_currency])
    finish_selected = Currency.find_selected_cur(currencies, params[:finish_currency])

    orders = Poloniex.order_book({currencyPair: 'ALL', depth: Poloniex.limit_order_book})
    pairs = Pair.parse_to_pairs(selected_pairs, currencies)
    Pair.add_orders(pairs, orders)

    graph = Graph.new(currencies, pairs)
    ways = graph.ways(start_currency, finish_selected)

    forkFinder = ForkFinder.new(commission: Poloniex.commission,
                                pairs: pairs,
                                profit_percent: params[:profit],
                                exchanges_from: params[:exchanges_from],
                                limit: params[:limit],
                                exchanges_to: params[:exchanges_to])

    forks = forkFinder.find(ways, coins: params[:coins])

    render partial: 'fork/forks', locals: {forks: forks}, layout: false
  end

  private

  def currencies
    Poloniex.ticker.keys.map { |pair| Pair.split(pair) }.flatten.uniq
  end

end
