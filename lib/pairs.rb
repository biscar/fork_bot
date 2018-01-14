require 'rgl/bellman_ford'
require 'rgl/adjacency'
require 'rgl/dijkstra'
require 'rgl/dot'
require 'rgl/edmonds_karp'
require 'rgl/bipartite'

class Pairs

  attr_reader :pairs

  def initialize(pairs = [])

    # curs = ["USD", "EUR", "RUB", "PLN", "UAH", "BTC", "LTC", "DOGE", "DASH", "ETH", "WAVES", "ZEC", "USDT", "XMR", "XRP", "KICK", "ETC", "BCH"]
    #
    # @curs = curs.map { |c| Currency.new(c) }
    #
    # # nodes =  ["BTC_USD", "BTC_EUR", "BTC_RUB", "BTC_UAH", "BTC_PLN", "BCH_BTC", "BCH_USD", "BCH_RUB", "BCH_ETH", "DASH_BTC",
    # #           "DASH_USD", "DASH_RUB", "ETH_BTC", "ETH_LTC", "ETH_USD", "ETH_EUR", "ETH_RUB", "ETH_UAH", "ETH_PLN",
    # #           "ETC_BTC", "ETC_USD", "ETC_RUB", "LTC_BTC", "LTC_USD", "LTC_EUR", "LTC_RUB", "ZEC_BTC", "ZEC_USD",
    # #           "ZEC_EUR", "ZEC_RUB", "XRP_BTC", "XRP_USD", "XRP_RUB", "XMR_BTC", "XMR_USD", "XMR_EUR", "BTC_USDT",
    # #           "ETH_USDT", "USDT_USD", "USDT_RUB", "USD_RUB", "DOGE_BTC", "WAVES_BTC", "WAVES_RUB", "KICK_BTC", "KICK_ETH"]

    @curs = Exmo.new.currency.map { |c| Currency.new(c) }
    pairs = Exmo.new.pair_settings.keys
    orders = Exmo.new.order_book(pairs)

    @pairs = []
    pairs.each do |name|
      split = name.split('_')

      first_c = @curs.detect { |t| t.name == split[0] }
      last_c = @curs.detect { |t| t.name == split[1] }

      pair = Pair.new(first_c, last_c)
      pair.order_book = orders[name]

      @pairs << pair
    end

  end


  def find_usd
    ForkFinder.find(@curs,@pairs, @curs.first)
  end

end