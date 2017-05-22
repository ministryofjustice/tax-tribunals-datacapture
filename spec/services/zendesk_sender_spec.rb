require 'rails_helper'

RSpec.describe ZendeskSender do
  let(:form_object) {
    Surveys::FeedbackForm.new(
      rating: 5, comment: 'very nice service', email: email, referrer: '/whatever', user_agent: 'Safari'
    )
  }

  subject { described_class.new(form_object) }

  before(:each) do
    stub_request(:post, %r{\Ahttps://tax-tribunals.zendesk.com/api/v2/tickets\z}).with(
      body: {
        ticket: {
          requester: requester_details,
          subject: 'Feedback',
          comment: { body: 'very nice service' },
          custom_fields: [
            {id: '79094767', value: 'datacapture_app'},
            {id: '79531628', value: 'Safari'},
            {id: '79094927', value: '/whatever'},
            {id: '79096207', value: 5}
          ]
        }}.to_json
    ).to_return(status: 201, body: '', headers: {})
  end

  describe '#send!' do
    context 'when email is provided' do
      let(:requester_details) { {name: 'user.name', email: 'user.name@example.com'} }
      let(:email) { 'user.name@example.com' }

      it 'creates a ticket with the details from the form_object' do
        expect(ZendeskAPI::Ticket).to receive(:create!).and_call_original
        subject.send!
      end
    end

    context 'when email is not provided' do
      let(:requester_details) { nil }
      let(:email) { '' }

      it 'creates a ticket with the details from the form_object' do
        expect(ZendeskAPI::Ticket).to receive(:create!).and_call_original
        subject.send!
      end
    end
  end
end
