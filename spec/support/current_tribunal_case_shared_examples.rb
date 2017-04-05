require 'rails_helper'

RSpec.shared_examples 'checks the validity of the current tribunal case' do
  context 'when there is no case in the session' do
    let(:current_tribunal_case) { nil }

    it 'redirects to the case not found error page' do
      expect(response).to redirect_to(case_not_found_errors_path)
    end
  end

  context 'when there is a case with submission in progress in the session' do
    let(:current_tribunal_case) { instance_double(TribunalCase, case_status: CaseStatus::SUBMIT_IN_PROGRESS) }

    it 'redirects to the case already submitted error page' do
      expect(response).to redirect_to(case_submitted_errors_path)
    end
  end

  context 'when there is an already submitted case in the session' do
    let(:current_tribunal_case) { instance_double(TribunalCase, case_status: CaseStatus::SUBMITTED) }

    it 'redirects to the case already submitted error page' do
      expect(response).to redirect_to(case_submitted_errors_path)
    end
  end
end

RSpec.shared_examples 'checks the validity of the current tribunal case on create' do |additional_params|
  describe 'tribunal case checks on create' do
    before do
      additional_params ||= {}
      allow(subject).to receive(:current_tribunal_case).and_return(current_tribunal_case)
      post :create, params: additional_params
    end

    include_examples 'checks the validity of the current tribunal case'
  end
end

RSpec.shared_examples 'checks the validity of the current tribunal case on destroy' do |additional_params|
  describe 'tribunal case checks on destroy' do
    before do
      additional_params ||= {}
      allow(subject).to receive(:current_tribunal_case).and_return(current_tribunal_case)
      delete :destroy, params: {id: 'anything'}.merge(additional_params)
    end

    include_examples 'checks the validity of the current tribunal case'
  end
end
