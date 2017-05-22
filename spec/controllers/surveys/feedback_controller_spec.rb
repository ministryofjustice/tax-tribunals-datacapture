require 'rails_helper'

RSpec.describe Surveys::FeedbackController, type: :controller do
  describe '#new' do
    it 'responds with HTTP success' do
      get :new
      expect(response).to be_successful
    end

    context 'referrer' do
      before do
        request.env['HTTP_REFERER'] = 'https://www.test.com/my/step'
      end

      it 'should assign the referrer path to the form object' do
        get :new
        expect(assigns[:form_object].referrer).to eq('/my/step')
      end
    end
  end

  describe '#create' do
    let(:form_object) {double('form object', save: saved)}

    before do
      request.env['HTTP_USER_AGENT'] = 'Safari'

      expect(Surveys::FeedbackForm).to receive(:new).with(
        rating: rating,
        comment: 'my feedback here',
        referrer: '/my/step',
        user_agent: 'Safari'
      ).and_return(form_object)
    end

    context 'when the form object saves successfully' do
      let(:rating) { '5' }
      let(:saved) { true }

      it 'redirects to thanks page' do
        post :create, params: {surveys_feedback_form: {
          referrer: '/my/step',
          rating: rating,
          comment: 'my feedback here'
        }}

        expect(response).to redirect_to(thanks_surveys_feedback_path)
      end
    end

    context 'when the form object does not save successfully' do
      let(:rating) { '10' }
      let(:saved) { false }

      it 're-renders the form' do
        post :create, params: {surveys_feedback_form: {
          referrer: '/my/step',
          rating: rating,
          comment: 'my feedback here'
        }}

        expect(subject).to render_template(:new)
      end
    end
  end
end
