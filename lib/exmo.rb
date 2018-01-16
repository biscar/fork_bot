require 'net/https'
require 'json'

class Exmo

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
    ApiBase.post(uri('order_book'), {pair: pairs.join(',')}.merge(params))
  end

  def ticker
    ApiBase.post(uri('ticker'), {pair: 'BTC_USD'})
  end

  def pair_settings
    ApiBase.post(uri('pair_settings'))
  end

  private

  HOST = 'https://api.exmo.com/v1'.freeze

  def uri(path)
    URI([HOST, path].join('/'))
  end


end