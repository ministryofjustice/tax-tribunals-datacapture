require 'spec_helper'

RSpec.shared_examples 'an end point step controller' do
  describe '#show' do
    context 'when no case exists in the session' do
      it 'redirects to the invalid session error page' do
        local_get :show
        expect(response).to redirect_to(invalid_session_errors_path)
      end
    end

    context 'when a case is in progress' do
      let(:tribunal_case) { TribunalCase.create(case_type: CaseType::OTHER) }

      it 'is successful' do
        local_get :show, session: { tribunal_case_id: tribunal_case.id }
        expect(response).to render_template(:show)
      end
    end
  end
end

RSpec.shared_examples 'an end of navigation controller' do
  context 'navigation stack' do
    let(:tribunal_case) { TribunalCase.create(case_type: CaseType::OTHER, navigation_stack: ['/not', '/empty']) }

    it 'clears the navigation stack' do
      local_get :show, session: {tribunal_case_id: tribunal_case.id}

      tribunal_case.reload
      expect(tribunal_case.navigation_stack).to be_empty
    end
  end
end
