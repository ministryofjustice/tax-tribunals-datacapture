require 'rails_helper'

RSpec.describe NormalisedEmailType do
  let(:coerced_value) { subject.cast(value) }
  let(:replacement_char) { coerced_value.split.uniq }

  describe 'normalising hyphens' do
    let(:value) { "\u2010 \u2011 \u2012 \u2013 \u2014 \u2015" }
    it { expect(replacement_char).to eq(['-']) }
  end

  describe 'normalising single quotes' do
    let(:value) { "\u0060 \u2018 \u2019 \u2032" }
    it { expect(replacement_char).to eq(["'"]) }
  end
end
