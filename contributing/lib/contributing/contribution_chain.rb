require 'aggregate_root'

module Contributing
  class ContributionChain
    include AggregateRoot

    class InconsecutivePeriodError < StandardError
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
      @state = nil
    end

    def create(command:)
      validate_consecutiveness_of!(command.period)

      apply ContributionCreated.new(
        data: { employee_name: employee_name, period: command.period, money: command.money }
      )
    end

    private

    attr_reader :employee_name

    def validate_consecutiveness_of!(period)
      most_recent_contribution = ReadModels::Contributions::Contribution.where(employee_name: employee_name)
                                                                        .sort_by(&:ends_on)
                                                                        .last

      return unless most_recent_contribution.present?

      raise InconsecutivePeriodError unless (Date.parse(period.starts_on) > most_recent_contribution.ends_on)
    end

    def apply_contribution_created(event)
      @starts_on = event.data[:period].starts_on
      @ends_on = event.data[:period].ends_on
      @amount = event.data[:money].amount
      @currency = event.data[:money].currency
    end

  end
end
