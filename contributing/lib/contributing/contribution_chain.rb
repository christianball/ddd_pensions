require 'aggregate_root'

module Contributing
  class ContributionChain
    include AggregateRoot

    class NonConsecutivePeriodError < StandardError
      def message
        "A new contribution must begin after the employee's most recent existing contribution ends."
      end
    end

    def initialize(employee_name:)
      @employee_name = employee_name
      @starts_on = nil
      @ends_on = nil
      @amount = nil
      @currency = nil
    end

    def create(command: command)
      validate_consecutiveness_of!(command.period)

      apply ContributionCreated.new(data: {
        employee_name: employee_name,
        starts_on: command.period.starts_on,
        ends_on: command.period.ends_on,
        amount: command.money.amount,
        currency: command.money.currency,
        level: 'signup'
      })
    end

    private

    attr_reader :employee_name

    def validate_consecutiveness_of!(period)
      most_recent_contribution = ReadModels::Contributions::Contribution.where(employee_name: employee_name)
                                                                        .sort_by(&:ends_on)
                                                                        .last

      return unless most_recent_contribution.present?

      raise InconsecutivePeriodError unless (period.starts_on > most_recent_contribution.ends_on)
    end

    def apply_contribution_created(event)
      @starts_on = event.data[:starts_on]
      @ends_on = event.data[:ends_on]
      @amount = event.data[:amount]
      @currency = event.data[:currency]
    end

  end
end
