require 'rails_helper'

RSpec.describe Steps::Closure::CheckAnswersController, type: :controller do
  it_behaves_like 'an end point step controller'

  context 'case details presenter' do
    let(:tribunal_case) { TribunalCase.create(case_type: CaseType::OTHER) }

    it 'assigns the presenter' do
      get :show, session: {tribunal_case_id: tribunal_case.id}

      presenter = assigns[:tribunal_case]
      expect(presenter).to be_an_instance_of(ClosurePresenter)
    end
  end

  context 'PDF format' do
    let(:current_tribunal_case) { instance_double(TribunalCase) }
    let(:pdf_creator_double) { instance_double(CaseDetailsPdf, generate: 'some pdf content', filename: 'filename123.pdf') }

    before do
      allow(subject).to receive(:current_tribunal_case).and_return(current_tribunal_case)
      expect(CaseDetailsPdf).to receive(:new).with(current_tribunal_case, an_instance_of(described_class)).and_return(pdf_creator_double)
    end

    it 'generates and sends the case details PDF' do
      get :show, format: :pdf
      expect(response).to have_http_status(:ok)
      expect(response.headers['Content-Disposition']).to eq('inline; filename="filename123.pdf"')
      expect(response.body).to eq('some pdf content')
    end
  end
end
