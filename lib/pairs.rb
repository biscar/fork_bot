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


    nodes =  ["BTC_USD", "BCH_BTC", "BCH_USD", "ETH_BTC", "ETH_USD", "BCH_ETH"]

    usd = Currency.new("USD")
    btc = Currency.new("BTC")
    eth = Currency.new("ETH")
    bch = Currency.new("BCH")

    @curs = [usd, btc, eth, bch]

    # @weights = {
    #   [usd, btc] => 1/16000.to_f,
    #   [btc, usd] => 15000.to_f,
    #   [usd, bch] => 1/2800.to_f,
    #   [bch, usd] => 2700.to_f,
    #   [usd, eth] => 1/1400.to_f,
    #   [eth, usd] => 1300.to_f,
    #   [btc, eth] => 1/0.08.to_f,
    #   [eth, btc] => 0.07.to_f,
    #   [eth, bch] => 1/2.1.to_f,
    #   [bch, eth] => 2.2.to_f,
    #   [btc, bch] => 1/0.18.to_f,
    #   [bch, btc] => 0.2.to_f,
    # }

    @pairs = []
    nodes.each do |name|
      split = name.split('_')

      first_c = @curs.detect { |t| t.name == split[0] }
      last_c = @curs.detect { |t| t.name == split[1] }

      @pairs << Pair.new(first_c, last_c)
    end

    [15000.to_f, 2700.to_f, 1300.to_f, 0.07.to_f, 2.2.to_f, 0.2.to_f].each_with_index do |c, index|
      @pairs[index].rate = c
    end
  end

  def test



   g = Graph.new(@curs, @pairs)

   paths = g.graph.cycles_with_vertex(@curs.first)

   #find_rate(pairs, from_cur, to_cur)
   paths.each do |path|
     puts path.map(&:name).join('->')

     last_cur = nil
     current_cur = nil
     cof = 1;

     path.each do |cur|
       puts cur
       rate = Rates.find_rate(@pairs, cur, last_cur)
       cof = cof*rate

       last_cur = cur
     end

     puts "cof = #{cof}"

   end


  end



end