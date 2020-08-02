module Contributing
  class Money

    def initialize(amount:, currency:)
      @amount = amount
      @currency = currency
    end

    attr_reader :amount, :currency

    def <=>(other)
      (self.amount == other.amount) && (self.currency == other.currency)
    end

  end
end
