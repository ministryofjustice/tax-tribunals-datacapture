require 'rails_helper'

RSpec.shared_examples 'a generic step controller' do |form_class, decision_tree_class|
  describe '#update' do
    let(:form_object) { instance_double(form_class, attributes: { foo: double }) }
    let(:form_class_params_name) { form_class.name.underscore }
    let(:expected_params) { { form_class_params_name => { foo: 'bar' } } }

    context 'when there is no case in the session' do
      before do
        # Needed because some specs that include these examples stub current_tribunal_case,
        # which is undesirable for this particular test
        allow(controller).to receive(:current_tribunal_case).and_return(nil)
      end

      it 'redirects to the case not found error page' do
        put :update, params: expected_params
        expect(response).to redirect_to(case_not_found_errors_path)
      end
    end

    context 'when there is an already submitted case in the session' do
      let(:existing_case) { TribunalCase.create(case_status: CaseStatus::SUBMITTED) }

      before do
        # Needed because some specs that include these examples stub current_tribunal_case,
        # which is undesirable for this particular test
        allow(controller).to receive(:current_tribunal_case).and_call_original
      end

      it 'redirects to the case already submitted error page' do
        put :update, params: expected_params, session: { tribunal_case_id: existing_case.id }
        expect(response).to redirect_to(case_submitted_errors_path)
      end
    end

    context 'when a case in progress is in the session' do
      let(:existing_case) { TribunalCase.create(case_status: nil) }

      before do
        expect(controller).to receive(:store_step_path_in_session)
        allow(form_class).to receive(:new).and_return(form_object)
      end

      context 'when the form saves successfully' do
        before do
          expect(form_object).to receive(:save).and_return(true)
        end

        let(:decision_tree) { instance_double(decision_tree_class, destination: '/expected_destination') }

        it 'asks the decision tree for the next destination and redirects there' do
          expect(decision_tree_class).to receive(:new).and_return(decision_tree)
          put :update, params: expected_params, session: { tribunal_case_id: existing_case.id }
          expect(subject).to redirect_to('/expected_destination')
        end
      end

      context 'when the form fails to save' do
        before do
          expect(form_object).to receive(:save).and_return(false)
        end

        it 'renders the question page again' do
          put :update, params: expected_params, session: { tribunal_case_id: existing_case.id }
          expect(subject).to render_template(:edit)
        end
      end
    end
  end
end

RSpec.shared_examples 'a starting point step controller' do |options|
  let(:intent) { options.fetch(:intent) }

  describe '#edit' do
    before do
      # This should not be necessary, but without it David S. was getting
      # consistent errors when running the tests
      TribunalCase.delete_all
    end

    context 'when no case exists in the session yet' do
      it 'creates a new case' do
        expect { get :edit }.to change { TribunalCase.count }.by(1)
      end

      it 'responds with HTTP success' do
        get :edit
        expect(response).to be_successful
      end

      it 'initialize the case with the appropriate intent' do
        expect(TribunalCase).to receive(:create).with(
          intent: intent
        ).at_least(:once).and_return(double.as_null_object)

        get :edit
      end

      it 'sets the case ID in the session' do
        get :edit
        expect(session[:tribunal_case_id]).to eq(TribunalCase.first.id)
      end
    end

    context 'when a case exists in the session' do
      let!(:existing_case) { TribunalCase.create(navigation_stack: ['/not', '/empty']) }

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

      it 'clears the navigation stack in the session' do
        get :edit, session: { tribunal_case_id: existing_case.id }
        existing_case.reload

        expect(existing_case.navigation_stack).to eq([controller.request.fullpath])
      end
    end

    context 'saving the case for later on `edit`' do
      context 'for a signed in user' do
        let(:user) { instance_double(User) }

        before do
          sign_in(user)
        end

        it 'does not save the case for later' do
          expect(SaveCaseForLater).not_to receive(:new)
          get :edit
        end
      end
    end
  end

  describe '#update' do
    context 'saving the case for later on `update`' do
      context 'for a signed in user' do
        let(:user) { instance_double(User) }

        before do
          sign_in(user)
        end

        it 'saves the case for later' do
          expect(SaveCaseForLater).to receive(:new).with(
            an_instance_of(TribunalCase),
            user
          ).and_return(double.as_null_object)

          put :update, params: {}
        end
      end

      context 'for a signed out user' do
        it 'does not save the case for later' do
          expect(SaveCaseForLater).not_to receive(:new)
          put :update, params: {}
        end
      end
    end
  end
end

RSpec.shared_examples 'an intermediate step controller' do |form_class, decision_tree_class|
  include_examples 'a generic step controller', form_class, decision_tree_class

  describe '#edit' do
    context 'when no case exists in the session yet' do
      before do
        # Needed because some specs that include these examples stub current_tribunal_case,
        # which is undesirable for this particular test
        allow(controller).to receive(:current_tribunal_case).and_return(nil)
      end

      it 'redirects to the case not found error page' do
        get :edit
        expect(response).to redirect_to(case_not_found_errors_path)
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

RSpec.shared_examples 'an intermediate step controller without update' do
  before do
    expect(controller).to receive(:store_step_path_in_session)
  end

  context '#update' do
    it 'raises an exception' do
      expect { put :update }.to raise_error(AbstractController::ActionNotFound)
    end
  end

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
