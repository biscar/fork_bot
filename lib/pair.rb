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

end