class Rates

  class << self

    def find_rate(pairs, from_cur, to_cur)
      return 1 if from_cur.blank? || to_cur.blank?
      return 1 if from_cur == to_cur

      detect_rate(pairs, from_cur, to_cur)
    end

    private

    def detect_rate(pairs, from_cur, to_cur)
      direct_cur =  pairs.detect { |pair| pair.numerator == from_cur && pair.denominator == to_cur }
      undirect_cur = pairs.detect { |pair| pair.denominator == from_cur && pair.numerator == to_cur } unless direct_cur

      if direct_cur
        direct_cur.rate
      elsif undirect_cur
        1/undirect_cur.rate
      end
    end


  end

end