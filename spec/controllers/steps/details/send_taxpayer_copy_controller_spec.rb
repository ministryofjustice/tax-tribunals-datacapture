require 'rails_helper'

RSpec.describe Steps::Details::SendTaxpayerCopyController, type: :controller do
  let(:tribunal_case) { TribunalCase.new(taxpayer_type: UserType::TAXPAYER) }
  before do
    allow(controller).to receive(:current_tribunal_case).and_return(tribunal_case)
  end

  it_behaves_like 'an intermediate step controller', Steps::Details::SendApplicationDetailsForm, DetailsDecisionTree

  context 'when send copy selected yes' do
    let(:email_address) { 'test@email.com' }
    let(:phone_number) { '07777777777' }
    let(:tribunal_case) do
      TribunalCase.new(
        taxpayer_type: UserType::TAXPAYER,
        send_taxpayer_copy: SendApplicationDetails::BOTH,
        taxpayer_contact_email: email_address,
        taxpayer_contact_phone: phone_number
      )
    end

    it 'shows details' do
      expect(controller.send(:email_address)).to eq(email_address)
      expect(controller.send(:phone_number)).to eq(phone_number)
    end
  end

  context 'when send copy selected no' do
    let(:tribunal_case) do
      TribunalCase.new(
        taxpayer_type: UserType::TAXPAYER,
        send_taxpayer_copy: SendApplicationDetails::NONE,
      )
    end

    it 'email_address is blank' do
      expect(controller.send(:email_address)).to be_blank
    end
    it 'phone_number is blank' do
      expect(controller.send(:email_address)).to be_blank
    end
  end

  context 'when send copy not selected' do
    let(:tribunal_case) do
      TribunalCase.new(
        taxpayer_type: UserType::TAXPAYER,
        send_taxpayer_copy: nil,
      )
    end

    it 'email_address is blank' do
      expect(controller.send(:email_address)).to be_blank
    end
    it 'phone_number is blank' do
      expect(controller.send(:phone_number)).to be_blank
    end
  end
end
