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

    private

    PUBLIC_HOST = 'https://poloniex.com/public'.freeze

    def public_uri(command)
      URI("#{PUBLIC_HOST}?#{command.to_param}")
    end

    def public_command(command)
      {command: command}
    end

  end




end