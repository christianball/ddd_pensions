module Contributing
  class CreateContribution
    def self.call(*args)
      new(*args).call
    end

    def initialize(employee_name:, starts_on:, ends_on:, amount:, currency:)
      @employee_name = employee_name
      @period = to_period(starts_on, ends_on)
      @money = to_money(amount, currency)
    end

    attr_reader :period, :money

    def call
      Contributing::ContributionChain.new(employee_name: employee_name).create(command: self)
    end

    private

    attr_reader :employee_name

    def to_period(starts_on, ends_on)
      Period.new(starts_on: starts_on, ends_on: ends_on)
    end

    def to_money(amount, currency)
      Money.new(amount: amount, currency: currency)
    end

  end
end
