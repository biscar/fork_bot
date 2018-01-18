class ExmoController < ForkController

  def index
    @currencies = Exmo.new.currency.map { |c| Currency.new(c) }
    @pairs = Exmo.new.pair_settings.keys
  end

  def find_forks
    forks = []
    currencies = params[:currencies].map { |c| Currency.new(c) }
    start_currency = find_selected_cur(currencies, params[:start_currency])
    finish_selected = find_selected_cur(currencies, params[:finish_currency])

    if start_currency
      selected_pairs = params[:pairs]
      orders = Exmo.new.order_book(selected_pairs, limit: 1)
      pairs = get_pairs(selected_pairs, orders, currencies)
      graph = Graph.new(currencies, pairs)
      ways = graph.ways(start_currency, finish_selected)

      forkFinder = ForkFinder.new(commission: 0.2,
                                  pairs: pairs,
                                  profit_percent: params[:profit],
                                  exchanges_from: params[:exchanges_from],
                                  limit: params[:limit],
                                  exchanges_to: params[:exchanges_to])

      forks = forkFinder.find(ways)
    end

    render partial: 'fork/forks', locals: {forks: forks}, layout: false
  end

  def show_details
    details = params[:details].to_hash

    render partial: 'fork/details', locals: {details: details}, layout: false
  end

  def refresh_fork
    fork_pairs = get_fork_pairs(params[:details].to_hash)
    way = params[:way].to_hash.values.map { |w| w['name'] }
    currencies = way.uniq.map { |c| Currency.new(c) }
    way = way.map { |name| find_selected_cur(currencies, name) }

    orders = Exmo.new.order_book(fork_pairs, limit: 1)
    pairs = get_pairs(fork_pairs, orders, currencies)

    forkFinder = ForkFinder.new(commission: 0.2, pairs: pairs,)
    fork = forkFinder.recalc(way)

    render partial: 'fork/row', locals: {fork: fork, id: params[:id]}, layout: false
  end

  private

  def find_selected_cur(currencies, name)
    currencies.detect { |c| c.name == name }
  end

  def get_pairs(selected_pairs, orders, currencies)
    pairs = []

    selected_pairs.each do |name|
      split = name.split('_')

      first_c = currencies.detect { |t| t.name == split[0] }
      last_c = currencies.detect { |t| t.name == split[1] }

      pair = Pair.new(first_c, last_c)
      pair.order_book = orders[name]

      pairs << pair
    end

    pairs
  end

  def get_fork_pairs(details)
    details.values.map { |p| p['name'].gsub!('/', '_') }.uniq
  end

end
