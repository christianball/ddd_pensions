require_relative './spec_helper'

RSpec.describe Contributing::Money do
  subject { described_class.new(amount: amount, currency: currency) }

  let(:amount) { 10 }
  let(:currency) { 'pounds' }

  describe '#amount' do
    specify { expect(subject.amount).to eq(amount) }
  end

  describe '#currency' do
    specify { expect(subject.currency).to eq(currency) }
  end

  describe '#<=>' do
    it 'compares two Money objects and determines whether they are equal' do
      equal_other = described_class.new(amount: amount, currency: currency)
      different_amount_other = described_class.new(amount: 20, currency: currency)
      different_currency_other = described_class.new(amount: amount, currency: 'dollars')

      expect(subject <=> equal_other).to eq(true)
      expect(subject <=> different_amount_other).to eq(false)
      expect(subject <=> different_currency_other).to eq(false)
    end
  end
end
