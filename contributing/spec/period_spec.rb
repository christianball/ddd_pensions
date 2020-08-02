require_relative './spec_helper'

RSpec.describe Contributing::Period do
  subject { described_class.new(starts_on: starts_on, ends_on: ends_on) }

  let(:starts_on) { '01-01-2020' }
  let(:ends_on) { '31-01-2020' }

  describe '#starts_on' do
    specify { expect(subject.starts_on).to eq(Date.parse(starts_on)) }
  end

  describe '#ends_on' do
    specify { expect(subject.ends_on).to eq(Date.parse(ends_on)) }
  end

  describe '#<=>' do
    it 'compares two Period objects and determines whether they are equal' do
      equal_other = described_class.new(starts_on: starts_on, ends_on: ends_on)
      different_starts_on_other = described_class.new(starts_on: '02-01-2020', ends_on: ends_on)
      different_ends_on_other = described_class.new(starts_on: starts_on, ends_on: '30-01-2020')

      expect(subject <=> equal_other).to eq(true)
      expect(subject <=> different_starts_on_other).to eq(false)
      expect(subject <=> different_ends_on_other).to eq(false)
    end
  end
end
