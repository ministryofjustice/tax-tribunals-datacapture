require 'rails_helper'

RSpec.describe Steps::Details::CheckAnswersController, type: :controller do
  it_behaves_like 'an end point step controller'

  let!(:tribunal_case) { TribunalCase.create(case_type: CaseType::OTHER) }
  let(:presenter) { instance_double(CheckAnswers::AppealAnswersPresenter, pdf_params: { pdf: 'check_answers' }) }

  context 'HTML format' do
    it 'assigns the presenter' do
      expect(CheckAnswers::AppealAnswersPresenter).to receive(:new).with(tribunal_case, format: :html).and_return(presenter)

      get :show, session: { tribunal_case_id: tribunal_case.id }

      expect(subject).to render_template(:show)
      expect(assigns[:presenter]).to eq(presenter)
    end
  end

  context 'PDF format' do
    let(:format) { :pdf }

    it 'generates and sends the case details PDF' do
      expect(CheckAnswers::AppealAnswersPresenter).to receive(:new).with(tribunal_case, format: :pdf).and_return(presenter)

      get :show, format: :pdf, session: { tribunal_case_id: tribunal_case.id }

      expect(subject).to render_template(:show)
      expect(assigns[:presenter]).to eq(presenter)
      expect(response.headers['Content-Disposition']).to eq('inline; filename="check_answers.pdf"; filename*=UTF-8\'\'check_answers.pdf')
    end
  end

  describe '#resume' do
    let(:user) { User.new }

    context 'when user is signed in' do
      before do
        sign_in(user)
      end

      it 'renders the expected page' do
        get :resume, session: { tribunal_case_id: tribunal_case.id }
        expect(response).to render_template(:resume)
      end
    end

    context 'when user is not signed in' do
      it 'redirects to the sign-in page' do
        get :resume, session: { tribunal_case_id: tribunal_case.id }
        expect(response).to redirect_to(user_session_path)
      end
    end
  end
end
