class ForkController < ApplicationController

  def index

  end

  private

  def currencies(pairs)
    pairs.map { |pair| Pair.split(pair) }.flatten.uniq
  end

end
