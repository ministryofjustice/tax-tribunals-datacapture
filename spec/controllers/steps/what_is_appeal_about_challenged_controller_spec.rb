require 'rails_helper'

RSpec.describe Steps::WhatIsAppealAboutChallengedController, type: :controller do
  describe '#edit' do
    context 'when no case exists in the session yet' do
      it 'raises an exception' do
        expect { get :edit }.to raise_error(RuntimeError)
      end
    end

    context 'when a case exists in the session' do
      let!(:existing_case) { TribunalCase.create }

      it 'responds with HTTP success' do
        get :edit, session: { tribunal_case_id: existing_case.id }
        expect(response).to be_successful
      end
    end
  end

  describe '#update' do
    let(:what_is_appeal_about_challenged_form) { instance_double(WhatIsAppealAboutChallengedForm) }

    before do
      expect(WhatIsAppealAboutChallengedForm).to receive(:new).and_return(what_is_appeal_about_challenged_form)
    end

    context 'when the form saves successfully' do
      before do
        expect(what_is_appeal_about_challenged_form).to receive(:save).and_return(true)
      end

      let(:decision_tree) { instance_double(DecisionTree, destination: '/expected_destination') }

      it 'asks the decision tree for the next destination and redirects there' do
        expect(DecisionTree).to receive(:new).and_return(decision_tree)
        put :update
        expect(subject).to redirect_to('/expected_destination')
      end
    end

    context 'when the form fails to save' do
      before do
        expect(what_is_appeal_about_challenged_form).to receive(:save).and_return(false)
      end

      it 'renders the question page again' do
        put :update
        expect(subject).to render_template(:edit)
      end
    end
  end
end
