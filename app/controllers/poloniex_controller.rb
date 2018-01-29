class PoloniexController < ForkController

  def index
    @currencies = Currency.parse_to_currencies(currencies(Poloniex.ticker.keys))
    @pairs = Pair.parse_to_pairs(Poloniex.ticker.keys, @currencies)
  end

  def find_forks
    selected_pairs = params[:pairs]

    currencies = Currency.parse_to_currencies(currencies(selected_pairs))
    start_currency = Currency.find_selected_cur(currencies, params[:start_currency])
    finish_selected = Currency.find_selected_cur(currencies, params[:finish_currency])

    orders = Poloniex.order_book({currencyPair: 'ALL', depth: Poloniex.limit_order_book})
    pairs = Pair.parse_to_pairs(selected_pairs, currencies)
    Poloniex.add_orders(pairs, orders)

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

  def show_details
    details = params[:details].to_hash

    render partial: 'fork/details', locals: {details: details}, layout: false
  end

  def refresh_fork
    fork_pairs = Pair.get_fork_pairs(params[:details].to_hash)
    way = params[:way].to_hash.values.map { |w| w['name'] }
    currencies = Currency.parse_to_currencies(way.uniq)
    way = way.map { |name| Currency.find_selected_cur(currencies, name) }

    orders = Poloniex.order_book({currencyPair: 'ALL', depth: Poloniex.limit_order_book})
    pairs = Pair.parse_to_pairs(fork_pairs, currencies)
    Poloniex.add_orders(pairs, orders)

    forkFinder = ForkFinder.new(commission: Poloniex.commission, pairs: pairs)
    fork = forkFinder.recalc(way, coins: params[:coins])

    render partial: 'fork/row', locals: {fork: fork, id: params[:id]}, layout: false
  end



end
