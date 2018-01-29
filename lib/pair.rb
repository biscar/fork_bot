class Pair

  attr_reader :numerator, :denominator, :reversed
  attr_accessor :rate, :order_book

  def initialize(numerator, denominator, params = {})
    @numerator = numerator
    @denominator = denominator
    @reversed = params.fetch(:reversed, false)
  end

  def to_s
    "#{@numerator.to_s}/#{@denominator.to_s}"
  end

  def name
    self.to_s
  end

  def api_name
    self.to_s.gsub('/', '_')
  end

  def ask
    @ask ||= bid_top
  end

  def bid
    @bid ||= ask_top
  end

  def ask_top
    @ask_top ||= order_book.ask_top.to_f
  end

  def bid_top
    @bid_top ||= order_book.bid_top.to_f
  end

  def calc_bid_coins(coins, fee)
    rest = coins.dup
    total_coins = 0

    order_book.bids.each do |cost, total_from|
      cost = cost.to_f
      total_from = total_from.to_f

      if total_from >= rest
        total_coins += (order_book.calc_bid(rest, cost)*fee).round(8)
        rest = 0
      else
        total_coins += (order_book.calc_bid(total_from, cost)*fee).round(8)
        rest = rest - total_from
      end

      break if rest == 0
    end

    rest == 0 ? total_coins : nil
  end

  def calc_ask_coins(coins, fee)
    rest = coins.dup
    total_coins = 0

    order_book.asks.each do |cost, total_from, _|
      cost = cost.to_f
      total_from = total_from.to_f

      if total_from >= rest
        total_coins += ((order_book.calc_ask(rest, cost))*fee).round(8)
        rest = 0
      else
        total_coins += ((order_book.calc_ask(total_from, cost))*fee).round(8)
        rest = rest - total_from
      end

      break if rest == 0
    end

    rest == 0 ? total_coins : nil
  end


  class << self
    def split(pair)
      pair.split(/\/|_/)
    end

    def name_to_underscore(pair)
      pair.to_s.gsub('/', '_')
    end

    def parse_to_pairs(pairs, currencies, params = {})
      pairs.map do |names|
        first, last = Pair.split(names)

        first_c = currencies.detect { |t| t.name == first }
        last_c = currencies.detect { |t| t.name == last }

        Pair.new(first_c, last_c, params)
      end
    end

    def get_fork_pairs(details)
      details.values.map { |p| p['name'].gsub!('/', '_') }.uniq
    end

  end

end