class Rates

  class << self

    def find_rate(pairs, from_cur, to_cur)
      return 1 if from_cur.blank? || to_cur.blank?
      return 1 if from_cur == to_cur

      detect_rate(pairs, from_cur, to_cur)
    end

    def find_scope_coins(pairs, from_cur, to_cur, coins)
      return coins,to_cur if from_cur.blank? || to_cur.blank?
      return coins,to_cur if from_cur == to_cur

      detect_scope_coins(pairs, from_cur, to_cur, coins)
    end

    private

    def detect_rate(pairs, from_cur, to_cur)
     direct_pair, undirect_pair = detect_pair(pairs, from_cur, to_cur)

     result = if direct_pair
        [direct_pair.bid_top*direct_pair.fee, direct_pair]
      elsif undirect_pair
        [((1/undirect_pair.ask_top)*undirect_pair.fee).round(8), undirect_pair]
      end

      result
    end

    def detect_scope_coins(pairs, from_cur, to_cur, coins)
      direct_pair, undirect_pair = detect_pair(pairs, from_cur, to_cur)

      if direct_pair
        coins = direct_pair.calc_bid_coins(coins)
        [coins, direct_pair]
      elsif undirect_pair
        coins = undirect_pair.calc_ask_coins(coins)
        [coins, undirect_pair]
      end
    end

    def detect_pair(pairs, from_cur, to_cur)
      direct_pair = pairs.detect { |pair| pair.numerator == from_cur && pair.denominator == to_cur }
      undirect_pair = pairs.detect { |pair| pair.denominator == from_cur && pair.numerator == to_cur } unless direct_pair

      reversed = (direct_pair || undirect_pair).reversed

      if reversed
        [undirect_pair, direct_pair]
      else
        [direct_pair, undirect_pair]
      end
    end

  end

end