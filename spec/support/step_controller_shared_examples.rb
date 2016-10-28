require 'rails_helper'

RSpec.shared_examples 'a generic step controller' do |form_class|
  describe '#update' do
    let(:form_object) { instance_double(form_class) }

    before do
      expect(form_class).to receive(:new).and_return(form_object)
    end

    context 'when the form saves successfully' do
      before do
        expect(form_object).to receive(:save).and_return(true)
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
        expect(form_object).to receive(:save).and_return(false)
      end

      it 'renders the question page again' do
        put :update
        expect(subject).to render_template(:edit)
      end
    end
  end
end

RSpec.shared_examples 'an entrypoint step controller' do |form_class|
  include_examples 'a generic step controller', form_class

  describe '#edit' do
    context 'when no case exists in the session yet' do
      it 'creates a new case' do
        expect { get :edit }.to change { TribunalCase.count }.by(1)
      end

      it 'responds with HTTP success' do
        get :edit
        expect(response).to be_successful
      end

      it 'sets the case ID in the session' do
        get :edit
        expect(session[:tribunal_case_id]).to eq(TribunalCase.first.id)
      end
    end

    context 'when a case exists in the session' do
      let!(:existing_case) { TribunalCase.create }

      it 'does not create a new case' do
        expect {
          get :edit, session: { tribunal_case_id: existing_case.id }
        }.to_not change { TribunalCase.count }
      end

      it 'responds with HTTP success' do
        get :edit, session: { tribunal_case_id: existing_case.id }
        expect(response).to be_successful
      end

      it 'does not change the case ID in the session' do
        get :edit, session: { tribunal_case_id: existing_case.id }
        expect(session[:tribunal_case_id]).to eq(existing_case.id)
      end
    end
  end
end

RSpec.shared_examples 'a non-entrypoint step controller' do |form_class|
  include_examples 'a generic step controller', form_class

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
end
