require 'rails_helper'

RSpec.describe TaxTribs::SaveCaseForLater do
  let(:user) { instance_double(User) }

  subject { described_class.new(tribunal_case, user) }

  describe '#save' do
    context 'for a `nil` tribunal case' do
      let(:tribunal_case) { nil }

      it 'returns true' do
        expect(subject.save).to eq(true)
      end

      it 'does not send any email' do
        expect(NotifyMailer).not_to receive(:new_case_saved_confirmation)
        subject.save
      end

      it 'email_sent? is false' do
        subject.save
        expect(subject.email_sent?).to eq(false)
      end
    end

    context 'for a tribunal case already saved before (belongs to a user)' do
      let(:tribunal_case) { instance_double(TribunalCase, user: user, update: true) }

      it 'returns true' do
        expect(subject.save).to eq(true)
      end

      it 'does not trigger any update in the tribunal case' do
        expect(tribunal_case).not_to receive(:update)
        subject.save
      end

      it 'does not send any email' do
        expect(NotifyMailer).not_to receive(:new_case_saved_confirmation)
        subject.save
      end

      it 'email_sent? is false' do
        subject.save
        expect(subject.email_sent?).to eq(false)
      end
    end

    context 'for a never saved before tribunal case' do
      let(:tribunal_case) { instance_double(TribunalCase, user: nil, update: true) }
      let(:mailer_double) { double.as_null_object }

      before do
        allow(NotifyMailer).to receive(:new_case_saved_confirmation).with(tribunal_case).and_return(mailer_double)
      end

      it 'returns true' do
        expect(subject.save).to eq(true)
      end

      it 'links the tribunal case to the user' do
        expect(tribunal_case).to receive(:update).with(user: user)
        subject.save
      end

      it 'sends a confirmation email' do
        subject.save
        expect(mailer_double).to have_received(:deliver_later)
      end

      it 'email_sent? is true' do
        subject.save
        expect(subject.email_sent?).to eq(true)
      end
    end
  end
end
