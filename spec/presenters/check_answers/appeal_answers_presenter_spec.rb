require 'spec_helper'

module CheckAnswers
  describe AppealAnswersPresenter do
    let(:tribunal_case) { instance_double(TribunalCase) }
    subject { described_class.new(tribunal_case, format: format) }

    describe '#sections' do
      let(:taxpayer_section_presenter) { double(TaxpayerSectionPresenter, show?: true) }
      let(:appeal_section_presenter) { double(AppealSectionPresenter, show?: true) }
      let(:hardship_section_presenter) { double(HardshipSectionPresenter, show?: true) }
      let(:lateness_section_presenter) { double(LatenessSectionPresenter, show?: true) }
      let(:details_section_presenter) { double(DetailsSectionPresenter, show?: true) }

      before do
        allow(TaxpayerSectionPresenter).to receive(:new).with(tribunal_case, locale: :en).and_return(taxpayer_section_presenter)
        allow(AppealSectionPresenter).to receive(:new).with(tribunal_case, locale: :en).and_return(appeal_section_presenter)
        allow(HardshipSectionPresenter).to receive(:new).with(tribunal_case, locale: :en).and_return(hardship_section_presenter)
        allow(LatenessSectionPresenter).to receive(:new).with(tribunal_case, locale: :en).and_return(lateness_section_presenter)
        allow(DetailsSectionPresenter).to receive(:new).with(tribunal_case, locale: :en).and_return(details_section_presenter)
      end

      context 'in HTML format' do
        let(:format) { :html}

        it 'has the right sections' do
          expect(subject.sections.count).to eq(5)

          expect(subject.sections[0]).to eq(appeal_section_presenter)
          expect(subject.sections[1]).to eq(hardship_section_presenter)
          expect(subject.sections[2]).to eq(lateness_section_presenter)
          expect(subject.sections[3]).to eq(details_section_presenter)
          expect(subject.sections[4]).to eq(taxpayer_section_presenter)
        end
      end

      context 'in PDF format' do
        let(:format) { :pdf }

        it 'has the right sections' do
          expect(subject.sections.count).to eq(5)

          expect(subject.sections[0]).to eq(taxpayer_section_presenter)
          expect(subject.sections[1]).to eq(appeal_section_presenter)
          expect(subject.sections[2]).to eq(hardship_section_presenter)
          expect(subject.sections[3]).to eq(lateness_section_presenter)
          expect(subject.sections[4]).to eq(details_section_presenter)
        end
      end
    end
  end
end
