require_relative './spec_helper'

RSpec.describe Contributing::ContributionChain do
  subject { described_class.new(employee_name: employee_name) }

  let(:employee_name) { 'Christian' }
  let(:command) { instance_double(Contributing::CreateContribution, period: period, money: money) }
  let(:period) { instance_double(Contributing::Period, starts_on: '01-02-2020', ends_on: '28-02-2020') }
  let(:money) { instance_double(Contributing::Money, amount: 10, currency: 'pounds') }

  describe '#create' do
    context 'when the command is valid' do
      it 'successfully applies a ContributionCreated event' do
        expect { subject.create(command: command) }.not_to raise_error
        expect(subject).to have_applied(
          an_event(Contributing::ContributionCreated).with_data(
            employee_name: employee_name, period: period, money: money
          )
        )
      end
    end

    context 'when the command is invalid due to inconsecutive contribution periods for the employee' do
      before do
        ReadModels::Contributions::Contribution.create(
          employee_name: employee_name,
          starts_on: Date.new(2020,1,1),
          ends_on: Date.new(2020,2,1),
          amount: 10,
          currency: 'pounds'
        )
      end

      it 'raises an error of the expected type' do
        expect { subject.create(command: command) }.to raise_error(described_class::InconsecutivePeriodError)
      end
    end
  end
end
