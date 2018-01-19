class Pair

  attr_reader :numerator, :denominator
  attr_accessor :rate, :order_book

  def initialize(numerator, denominator)
    @numerator = numerator
    @denominator = denominator
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
    @ask ||= order_book['ask_top'].to_f
  end

  def bid
    @bid ||= order_book['bid_top'].to_f
  end

  def ask_top
    @ask_top ||= order_book['ask_top'].to_f
  end

  def bid_top
    @bid_top ||= order_book['bid_top'].to_f
  end

  class << self
    def split(pair)
      pair.split(/\/|_/)
    end

    def name_to_underscore(pair)
      pair.to_s.gsub('/', '_')
    end

    def parse_to_pairs(pairs, currencies)
      pairs.map do |names|
        first, last = Pair.split(names)

        first_c = currencies.detect { |t| t.name == first }
        last_c = currencies.detect { |t| t.name == last }

        Pair.new(first_c, last_c)
      end
    end

    def add_orders(pairs, orders)
      pairs.each  do |pair|
        pair.order_book = orders[pair.api_name]
      end
    end
  end

end