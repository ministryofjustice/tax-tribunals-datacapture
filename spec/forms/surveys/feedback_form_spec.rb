require 'spec_helper'

RSpec.describe Surveys::FeedbackForm do
  let(:arguments) { {
    comment: comment,
    email: email,
    referrer: referrer,
    user_agent: user_agent
  } }

  subject { described_class.new(arguments) }

  let(:comment) { 'my feedback here' }
  let(:email) { 'email@example.com' }
  let(:referrer) { '/path' }
  let(:user_agent) { 'Safari' }

  describe '#subject' do
    it { expect(subject.subject).to eq('Feedback') }
  end

  describe '#save' do
    context 'when comment is not given' do
      let(:comment) { nil }

      it 'returns false' do
        expect(subject.save).to be(false)
      end

      it 'has a validation error on the field' do
        expect(subject).to_not be_valid
        expect(subject.errors[:comment]).to_not be_empty
      end
    end

    context 'when email is not valid' do
      let(:email) { 'blah' }

      it 'returns false' do
        expect(subject.save).to be(false)
      end

      it 'has a validation error on the field' do
        expect(subject).to_not be_valid
        expect(subject.errors[:email]).to_not be_empty
      end
    end

    context 'allows blank email' do
      let(:email) { '' }

      it 'has no validation errors' do
        expect(subject).to be_valid
      end
    end

    context 'when the form is valid' do
      let(:zendesk_sender_double) { double('zendesk_sender_double') }

      it 'creates the ticket' do
        expect(TaxTribs::ZendeskSender).to receive(:new).with(subject).and_return(zendesk_sender_double)
        expect(zendesk_sender_double).to receive(:send!).and_return(true)
        expect(subject.save).to be(true)
      end
    end
  end
end
