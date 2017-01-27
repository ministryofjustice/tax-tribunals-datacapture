RSpec.describe ContactableEntityType do
  subject { described_class.new(value) }

  describe '#organisation?' do
    context 'when it is individual' do
      let(:value) { :individual }

      it { is_expected.not_to be_organisation }
    end

    context 'when it is company' do
      let(:value) { :company }

      it { is_expected.to be_organisation }
    end

    context 'when it is other organisation' do
      let(:value) { :other_organisation }

      it { is_expected.to be_organisation }
    end
  end
end
