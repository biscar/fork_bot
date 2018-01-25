require 'net/https'
require 'json'

class Exmo

  class << self

    def trades
      ApiBase.post(uri('trades'), {pair: 'BTC_USD'})
    end

    def currency
      ApiBase.post(uri('currency'))
    end

    # {
    #   "BTC_USD": {
    #     "ask_quantity": "3",
    #     "ask_amount": "500",
    #     "ask_top": "100",
    #     "bid_quantity": "1",
    #     "bid_amount": "99",
    #     "bid_top": "99",
    #     "ask": [[100,1,100],[200,2,400]],
    #     "bid": [[99,1,99]]
    #   }
    # }

    # ask_quantity - объем всех ордеров на продажу
    # ask_amount - сумма всех ордеров на продажу
    # ask_top - минимальная цена продажи
    # bid_quantity - объем всех ордеров на покупку
    # bid_amount - сумма всех ордеров на покупку
    # bid_top - максимальная цена покупки
    # bid - список ордеров на покупку, где каждая строка это цена, количество и сумма
    # ask - список ордеров на продажу, где каждая строка это цена, количество и сумма

    def order_book(pairs, params={})
      pairs = pairs.map { |n| Pair.name_to_underscore(n) }.join(',')

      ApiBase.post(uri('order_book'), {pair: pairs}.merge(params))
    end

    def ticker
      ApiBase.post(uri('ticker'), {pair: 'BTC_USD'})
    end

    def pair_settings
      ApiBase.post(uri('pair_settings'))
    end

    def commission
      COMMISSION
    end

    def limit_order_book
      LIMIT_ORDER_BOOK
    end

    def add_orders(pairs, orders)
      pairs.each  do |pair|
        pair.order_book = orders[pair.api_name]
      end
    end

    private

    HOST = 'https://api.exmo.com/v1'.freeze
    COMMISSION = 0.2
    LIMIT_ORDER_BOOK = 500

    def uri(path)
      URI([HOST, path].join('/'))
    end

  end

end