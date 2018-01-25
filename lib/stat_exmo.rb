class StatExmo

  def start
    currencies = Currency.parse_to_currencies(Exmo.currency)
    pairs = Pair.parse_to_pairs(Exmo.pair_settings.keys, currencies)
    start_currency = Currency.find_selected_cur(currencies, 'XRP')

    i = 0
    while true
     begin
      i += 1
      puts i
      orders = Exmo.order_book(pairs, limit: Exmo.limit_order_book)
      Pair.add_orders(pairs, orders)
      @graph ||= Graph.new(currencies, pairs)
      @ways ||= @graph.ways(start_currency)

      forkFinder = ForkFinder.new(commission: Exmo.commission, pairs: pairs, profit_percent: 0, limit: 10)

      forks = forkFinder.find(@ways, coins: 10)

      forks.each do |fork|
        File.open("#{Rails.root}/log/#{fork.to_s}", 'a+') do |file|
          file.write("#{Time.now.to_s} : #{fork.percentage_profit.round(3)}")
          file.write("\n")
        end
      end

      rescue
        puts 'error'
      end
    end
    nil
  end

end