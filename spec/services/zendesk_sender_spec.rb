require 'rails_helper'

RSpec.describe ZendeskSender do
  let(:form_object) {
    Surveys::FeedbackForm.new(
      rating: 5, comment: 'very nice service', referrer: '/whatever', user_agent: 'Safari'
    )
  }

  subject { described_class.new(form_object) }

  before(:each) do
    stub_request(:post, %r{\Ahttps://ministryofjustice.zendesk.com/api/v2/tickets\z}).with(
      body: {
        ticket: {
          subject: 'Feedback',
          comment: { body: 'very nice service' },
          custom_fields: [
            {id: '23757677', value: 'tax_tribunal'},
            {id: '23791776', value: 'Safari'},
            {id: '26047167', value: '/whatever'},
            {id: '114094159771', value: 5}
          ]
        }}.to_json
    ).to_return(status: 201, body: '', headers: {})
  end

  describe '#send!' do
    it 'creates a ticket with the details from the form_object' do
      expect(ZendeskAPI::Ticket).to receive(:create!).and_call_original
      subject.send!
    end
  end
end
