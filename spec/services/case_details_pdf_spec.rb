require 'spec_helper'

RSpec.describe CaseDetailsPdf do
  let!(:tribunal_case) { TribunalCase.create(case_attributes) }
  let(:decorated_tribunal_case) { AppealPresenter.new(tribunal_case) }
  let(:controller_ctx) { ApplicationController.new }

  let(:intent) { Intent::TAX_APPEAL }
  let(:taxpayer_type) { ContactableEntityType::INDIVIDUAL }
  let(:case_attributes) do
    {
      case_type: CaseType::OTHER,
      closure_case_type: ClosureCaseType::PERSONAL_RETURN,
      taxpayer_type: taxpayer_type,
      taxpayer_individual_first_name: 'Firstname',
      taxpayer_individual_last_name: 'Lastname',
      taxpayer_organisation_fao: 'Company Contact Name',
      has_representative: HasRepresentative::YES,
      representative_type: ContactableEntityType::INDIVIDUAL,
      representative_individual_first_name: 'Firstname',
      representative_individual_last_name: 'Lastname',
      representative_organisation_fao: 'Company Contact Name',
      files_collection_ref: 'd29210a8-f2fe-4d6f-ac96-ea4f9fd66687',
      case_reference: 'TC/2016/12345',
      outcome: 'my desired outcome',
      intent: intent
    }
  end

  subject { described_class.new(decorated_tribunal_case, controller_ctx) }


  describe '#filename' do
    let(:taxpayer_details_presenter) { instance_double(TaxpayerDetailsPresenter, name: 'Foo Bar') }
    it 'should generate an appropriate file name' do
      expect(decorated_tribunal_case).to receive(:taxpayer).and_return(taxpayer_details_presenter)
      expect(subject.filename).to eq('TC_2016_12345_HMRC_FooBar.pdf')
    end
  end

  describe '#generate' do
    before do
      allow(tribunal_case).to receive(:documents).and_return([])
      allow(controller_ctx).to receive(:current_tribunal_case).and_return(tribunal_case)
    end

    context 'for a tax appeal application' do
      let(:intent) { Intent::TAX_APPEAL }

      it 'should generate the PDF' do
        expect(controller_ctx).to receive(:render_to_string).at_least(:once).and_call_original

        expect(decorated_tribunal_case).to receive(:taxpayer).at_least(:once).and_call_original
        expect(decorated_tribunal_case).to receive(:representative).at_least(:once).and_call_original
        expect(decorated_tribunal_case).to receive(:documents).at_least(:once).and_call_original
        expect(decorated_tribunal_case).to receive(:appeal_type_answers).at_least(:once).and_call_original
        expect(decorated_tribunal_case).to receive(:appeal_lateness_answers).at_least(:once).and_call_original
        expect(decorated_tribunal_case).to receive(:outcome).at_least(:once).and_call_original

        expect(subject.generate).to match(/%PDF/)
      end
    end

    context 'for a closure application' do
      let(:intent) { Intent::CLOSE_ENQUIRY }
      let(:decorated_tribunal_case) { ClosurePresenter.new(tribunal_case) }

      it 'should generate the PDF' do
        expect(controller_ctx).to receive(:render_to_string).at_least(:once).and_call_original

        expect(decorated_tribunal_case).to receive(:taxpayer).at_least(:once).and_call_original
        expect(decorated_tribunal_case).to receive(:representative).at_least(:once).and_call_original
        expect(decorated_tribunal_case).to receive(:documents).at_least(:once).and_call_original
        expect(decorated_tribunal_case).to receive(:enquiry_answers).at_least(:once).and_call_original

        expect(subject.generate).to match(/%PDF/)
      end
    end

    context 'for an invalid intent' do
      let(:intent) { nil }

      it 'should raise an exception' do
        expect { subject.generate }.to raise_exception(/Invalid intent/)
      end
    end
  end

  describe '#generate_and_upload' do
    before do
      expect(controller_ctx).to receive(:render_to_string).and_return('rendered pdf')
      expect(DocumentUpload).to receive(:new).with(
        an_instance_of(File),
        filename: 'TC_2016_12345_HMRC_FirstnameLastname.pdf',
        content_type: 'application/pdf',
        collection_ref: 'd29210a8-f2fe-4d6f-ac96-ea4f9fd66687'
      ).and_return(uploader_double)
    end

    context 'upload successful' do
      let(:uploader_double) { instance_double(DocumentUpload, valid?: true, errors?: false, upload!: true) }

      it 'should generate the PDF and upload it' do
        expect(uploader_double).to receive(:upload!)
        subject.generate_and_upload
      end
    end

    context 'upload failed' do
      let(:uploader_double) { instance_double(DocumentUpload, valid?: true, errors?: true, upload!: true) }

      it 'should raise an exception' do
        expect { subject.generate_and_upload }.to raise_exception(Exception)
      end
    end
  end
end
