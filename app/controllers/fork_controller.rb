class ForkController < ApplicationController

  def index
    @currencies = Exmo.new.currency.map { |c| Currency.new(c) }


  end

  def find_forks
    currencies = Exmo.new.currency.map { |c| Currency.new(c) }

    selected_cur = find_selected_cur(currencies, params[:currency])
    forks = []
    if selected_cur
      #selected_pairs = Exmo.new.pair_settings.keys
      selected_pairs = ["BTC_USD", "BCH_BTC", "BCH_USD", "ETH_BTC", "ETH_USD", "BCH_ETH"]
      orders = Exmo.new.order_book(selected_pairs)
      pairs = get_pairs(selected_pairs, orders, currencies)
      forks = ForkFinder.find(currencies, pairs, selected_cur, profit: params[:profit])
    end

    render partial: 'fork/forks', locals: {forks: forks}, layout: false
  end

  def show_details
    details = params[:details].to_hash

    render partial: 'fork/details', locals: {details: details}, layout: false
  end

  private

  def find_selected_cur(currencies, name)
    currencies.detect { |c| c.name == name}
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

end
