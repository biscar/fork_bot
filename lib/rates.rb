class Rates

  class << self

    def find_rate(pairs, from_cur, to_cur)
      return 1 if from_cur.blank? || to_cur.blank?
      return 1 if from_cur == to_cur

      detect_rate(pairs, from_cur, to_cur)
    end

    def find_scope_coins(pairs, from_cur, to_cur, coins, fee)
      return coins,to_cur if from_cur.blank? || to_cur.blank?
      return coins,to_cur if from_cur == to_cur

      detect_scope_coins(pairs, from_cur, to_cur, coins, fee)
    end

    private

    def detect_rate(pairs, from_cur, to_cur)
     direct_pair, undirect_pair = detect_pair(pairs, from_cur, to_cur)

     result = if direct_pair
        [direct_pair.bid_top, direct_pair]
      elsif undirect_pair
        [(1/undirect_pair.ask_top).round(8), undirect_pair]
      end

      result
    end

    def detect_scope_coins(pairs, from_cur, to_cur, coins, fee)
      direct_pair, undirect_pair = detect_pair(pairs, from_cur, to_cur)

      if direct_pair
        coins = direct_pair.calc_bid_coins(coins, fee)
        [coins, direct_pair]
      elsif undirect_pair
        coins = undirect_pair.calc_ask_coins(coins, fee)
        [coins, undirect_pair]
      end
    end

    def detect_pair(pairs, from_cur, to_cur)
      direct_pair = pairs.detect { |pair| pair.numerator == from_cur && pair.denominator == to_cur }
      undirect_pair = pairs.detect { |pair| pair.denominator == from_cur && pair.numerator == to_cur } unless direct_pair

      [direct_pair, undirect_pair]
    end


  end

end