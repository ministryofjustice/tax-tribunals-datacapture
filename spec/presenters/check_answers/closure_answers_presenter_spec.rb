require 'spec_helper'

module CheckAnswers
  describe ClosureAnswersPresenter do
    let(:tribunal_case) { instance_double(TribunalCase) }
    subject { described_class.new(tribunal_case, format: format) }

    describe '#sections' do
      let(:taxpayer_section_presenter) { double(TaxpayerSectionPresenter, show?: true) }
      let(:closure_type_section_presenter) { double(ClosureTypeSectionPresenter, show?: true) }
      let(:closure_details_section_presenter) { double(ClosureDetailsSectionPresenter, show?: true) }

      before do
        allow(TaxpayerSectionPresenter).to receive(:new).with(tribunal_case).and_return(taxpayer_section_presenter)
        allow(ClosureTypeSectionPresenter).to receive(:new).with(tribunal_case).and_return(closure_type_section_presenter)
        allow(ClosureDetailsSectionPresenter).to receive(:new).with(tribunal_case).and_return(closure_details_section_presenter)
      end

      context 'in HTML format' do
        let(:format) { :html}

        it 'has the right sections' do
          expect(subject.sections.count).to eq(3)

          expect(subject.sections[0]).to eq(closure_type_section_presenter)
          expect(subject.sections[1]).to eq(closure_details_section_presenter)
          expect(subject.sections[2]).to eq(taxpayer_section_presenter)
        end
      end

      context 'in PDF format' do
        let(:format) { :pdf }

        it 'has the right sections' do
          expect(subject.sections.count).to eq(3)

          expect(subject.sections[0]).to eq(taxpayer_section_presenter)
          expect(subject.sections[1]).to eq(closure_type_section_presenter)
          expect(subject.sections[2]).to eq(closure_details_section_presenter)
        end
      end
    end
  end
end
