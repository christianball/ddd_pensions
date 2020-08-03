module ReadModels
  module Contributions
    class OnCreation

      def call(event)
        contribution_from(event).save!
      end

      private

      def contribution_from(event)
        Contribution.new(
          employee_name: event.data[:employee_name],
          starts_on: event.data[:starts_on],
          ends_on: event.data[:ends_on],
          amount: event.data[:amount],
          currency: event.data[:currency]
        )
      end

    end
  end
end
