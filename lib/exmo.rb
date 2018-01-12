require 'net/https'
require 'json'

class Exmo

  def trades
    ApiBase.post(uri('trades'), {pair: 'BTC_USD'})
  end

  def currency
    ApiBase.post(uri('currency'))
  end

  def order_book
    ApiBase.post(uri('order_book'), {pair: 'BTC_USD'})
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