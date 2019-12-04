require 'spec_helper'

RSpec.describe Surveys::FeedbackForm do
  let(:arguments) { {
    comment: comment,
    email: email,
    name: name,
    assistance_type: assistance_type
  } }

  subject { described_class.new(arguments) }

  let(:comment) { 'my feedback here' }
  let(:email) { 'email@example.com' }
  let(:name) { 'Jane Doe' }
  let(:assistance_type) { 'none' }

  describe '#subject' do
    it { expect(subject.subject).to eq('Report a problem') }
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

    context 'refuse blank email' do
      let(:email) { '' }

      it 'has validation errors' do
        expect(subject).not_to be_valid
      end
    end

    context 'when the form is valid' do
      let(:mailer_double) { double.as_null_object }

      before do
        allow(NotifyMailer).to receive(:report_problem).with(subject).and_return(mailer_double)
      end

      it 'sends notification' do
        subject.save
        expect(mailer_double).to have_received(:deliver_now)
      end
    end
  end
end
