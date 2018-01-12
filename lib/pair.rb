class Pair

  attr_reader :numerator, :denominator
  attr_accessor :rate

  def initialize(numerator, denominator)
    @numerator = numerator
    @denominator = denominator
  end

  def to_s
    "#{@numerator.to_s}/#{@denominator.to_s}"
  end


  # def self.traded?(first_pair, last_pair)
  #   (first_pair.start_cur == last_pair.start_cur) ||
  #     (first_pair.end_cur == last_pair.end_cur) ||
  #     (first_pair.start_cur == last_pair.end_cur) ||
  #     (first_pair.end_cur == last_pair.start_cur)
  # end



end