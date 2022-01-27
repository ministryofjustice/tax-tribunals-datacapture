require 'rails_helper'

RSpec.describe ApplicationController do
  controller do
    def invalid_session; raise Errors::InvalidSession; end
    def case_not_found; raise Errors::CaseNotFound; end
    def case_submitted; raise Errors::CaseSubmitted; end
    def another_exception; raise Exception; end
  end

  context 'Exceptions handling' do
    before do
      allow(Rails).to receive_message_chain(:application, :config, :consider_all_requests_local).and_return(false)
      allow(Rails).to receive_message_chain(:application, :config, :maintenance_enabled).and_return(false)
    end

    context 'Errors::InvalidSession' do
      it 'should not report the exception, and redirect to the error page' do
        routes.draw { get 'invalid_session' => 'anonymous#invalid_session' }

        expect(Sentry).not_to receive(:capture_exception)

        local_get :invalid_session
        expect(response).to redirect_to(invalid_session_errors_path)
      end
    end

    context 'Errors::CaseNotFound' do
      it 'should not report the exception, and redirect to the error page' do
        routes.draw { get 'case_not_found' => 'anonymous#case_not_found' }

        expect(Sentry).not_to receive(:capture_exception)

        local_get :case_not_found
        expect(response).to redirect_to(case_not_found_errors_path)
      end
    end

    context 'Errors::CaseSubmitted' do
      it 'should not report the exception, and redirect to the error page' do
        routes.draw { get 'case_submitted' => 'anonymous#case_submitted' }

        expect(Sentry).not_to receive(:capture_exception)

        local_get :case_submitted
        expect(response).to redirect_to(case_submitted_errors_path)
      end
    end

    context 'Other exceptions' do
      it 'should report the exception, and redirect to the error page' do
        routes.draw { get 'another_exception' => 'anonymous#another_exception' }

        expect(Sentry).to receive(:capture_exception)

        local_get :another_exception
        expect(response).to redirect_to(unhandled_errors_path)
      end
    end
  end
end
