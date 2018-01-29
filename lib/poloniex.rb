require 'net/https'
require 'json'


class Poloniex

  class << self

    def ticker
      ApiBase.get(public_uri(public_command('returnTicker')))
    end

    def currencies
      ApiBase.get(public_uri(public_command('returnCurrencies')))
    end

    def order_book(params)
      ApiBase.get(public_uri(public_command('returnOrderBook').merge(params)))
    end

    def limit_order_book
      LIMIT_ORDER_BOOK
    end

    def commission
      COMMISSION
    end

    def add_orders(pairs, orders)
      pairs.each do |pair|
        ob = orders[pair.api_name]
        order_book = OrderBook.new(asks: ob['asks'], bids: ob['bids'], reverse_calc: true)
        pair.order_book = order_book
      end
    end

    private

    PUBLIC_HOST = 'https://poloniex.com/public'.freeze
    COMMISSION = 0.2
    LIMIT_ORDER_BOOK = 500

    def public_uri(command)
      URI("#{PUBLIC_HOST}?#{command.to_param}")
    end

    def public_command(command)
      {command: command}
    end

  end




end