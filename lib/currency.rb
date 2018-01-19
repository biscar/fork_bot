class Currency
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def to_s
    name
  end

  class << self

    def find_selected_cur(currencies, name)
      currencies.detect { |c| c.name == name }
    end

    def parse_to_currencies(names)
      names.map { |name| Currency.new(name) }
    end

  end

end