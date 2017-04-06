require 'rails_helper'

RSpec.describe ApplicationController do
  controller do
    def case_not_found; raise Errors::CaseNotFound; end
    def case_submitted; raise Errors::CaseSubmitted; end
    def another_exception; raise Exception; end
  end

  describe '#after_sign_in_path_for' do
    let(:resource) { double('resource') }

    it 'returns the root path' do
      allow(subject).to receive(:root_path).and_return('foo')
      expect(subject.after_sign_in_path_for(resource)).to eq('foo')
    end
  end

  context 'Exceptions handling' do
    before do
      allow(Rails).to receive_message_chain(:application, :config, :consider_all_requests_local).and_return(false)
    end

    context 'Errors::CaseNotFound' do
      it 'should not report the exception, and redirect to the error page' do
        routes.draw { get 'case_not_found' => 'anonymous#case_not_found' }

        expect(Raven).not_to receive(:capture_exception)

        get :case_not_found
        expect(response).to redirect_to(case_not_found_errors_path)
      end
    end

    context 'Errors::CaseSubmitted' do
      it 'should not report the exception, and redirect to the error page' do
        routes.draw { get 'case_submitted' => 'anonymous#case_submitted' }

        expect(Raven).not_to receive(:capture_exception)

        get :case_submitted
        expect(response).to redirect_to(case_submitted_errors_path)
      end
    end

    context 'Other exceptions' do
      it 'should report the exception, and redirect to the error page' do
        routes.draw { get 'another_exception' => 'anonymous#another_exception' }

        expect(Raven).to receive(:capture_exception)

        get :another_exception
        expect(response).to redirect_to(unhandled_errors_path)
      end
    end
  end
end
