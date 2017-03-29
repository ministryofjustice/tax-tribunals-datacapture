require 'spec_helper'

module CheckAnswers
  describe SectionPresenter do
    subject { described_class.new(tribunal_case) }
    let(:tribunal_case) { instance_double(TribunalCase) }

    describe '#to_partial_path' do
      it 'returns the partial path' do
        expect(subject.to_partial_path).to eq('section')
      end
    end

    describe '#show?' do
      it 'returns true' do
        expect(subject.show?).to eq(true)
      end
    end
  end
end
