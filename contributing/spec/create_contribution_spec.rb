require_relative './spec_helper'

RSpec.describe Contributing::CreateContribution do
  subject do
    described_class.new(
      employee_name: employee_name, starts_on: starts_on, ends_on: ends_on, amount: amount, currency: currency
    )
  end

  let(:employee_name) { 'Christian' }
  let(:starts_on) { '01-01-2020' }
  let(:ends_on) { '31-01-2020' }
  let(:amount) { 10 }
  let(:currency) { 'pounds' }
  let(:contribution_chain) { instance_double(Contributing::ContributionChain) }

  before { allow(Contributing::ContributionChain).to receive(:new).and_return(contribution_chain) }

  it 'wraps the starts_on and ends_on arguments in the expected value object' do
    expect(Contributing::Period).to receive(:new).with(starts_on: starts_on, ends_on: ends_on).and_call_original
    expect(subject.period).to be_an_instance_of(Contributing::Period)

    subject
  end

  it 'wraps the amount and currency arguments in the expected value object' do
    expect(Contributing::Money).to receive(:new).with(amount: amount, currency: currency).and_call_original
    expect(subject.money).to be_an_instance_of(Contributing::Money)

    subject
  end

  describe '#call' do
    it 'calls the ContributionChain aggregate for the employee with the provided name' do
      expect(Contributing::ContributionChain).to receive(:new).with(employee_name: employee_name).and_call_original

      subject.call
    end

    it 'relays itself to the ContributionChain aggregate via the expected method call' do
      expect(contribution_chain).to receive(:create).with(command: instance_of(described_class))

      subject.call
    end
  end
end
