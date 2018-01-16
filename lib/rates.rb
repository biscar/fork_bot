class Rates

  class << self

    def find_rate(pairs, from_cur, to_cur)
      return 1 if from_cur.blank? || to_cur.blank?
      return 1 if from_cur == to_cur

      detect_rate(pairs, from_cur, to_cur)
    end

    private

    def detect_rate(pairs, from_cur, to_cur)
      direct_pair = pairs.detect { |pair| pair.numerator == from_cur && pair.denominator == to_cur }
      undirect_pair = pairs.detect { |pair| pair.denominator == from_cur && pair.numerator == to_cur } unless direct_pair

      if direct_pair
        [direct_pair.bid_top, direct_pair]
      elsif undirect_pair
        [(1/undirect_pair.ask_top).round(8), undirect_pair]
      end
    end


  end

end