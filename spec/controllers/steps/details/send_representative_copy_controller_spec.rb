require 'rails_helper'

RSpec.describe Steps::Details::SendRepresentativeCopyController, type: :controller do
  let(:tribunal_case) { TribunalCase.new(taxpayer_type: UserType::REPRESENTATIVE) }
  before do
    allow(controller).to receive(:current_tribunal_case).and_return(tribunal_case)
  end

  it_behaves_like 'an intermediate step controller', Steps::Details::SendApplicationDetailsForm, DetailsDecisionTree

  context 'when send copy selected yes' do
    let(:email_address) { 'test@email.com' }
    let(:tribunal_case) do
      TribunalCase.new(
        representative_type: UserType::REPRESENTATIVE,
        send_representative_copy: yes,
        representative_contact_email: email_address
      )
    end

    it 'shows email_address' do
      expect(controllor.send(:email_address)).to eq(email_address)
    end
  end

  context 'when send copy selected no' do
    let(:tribunal_case) do
      TribunalCase.new(
        representative_type: UserType::REPRESENTATIVE,
        send_representative_copy: no,
      )
    end

    it 'email_address is blank' do
      expect(controllor.send(:email_address)).to be_blank
    end
  end

  context 'when send copy not selected' do
    let(:tribunal_case) do
      TribunalCase.new(
        representative_type: UserType::REPRESENTATIVE,
        send_representative_copy: nil,
      )
    end

    it 'email_address is blank' do
      expect(controllor.send(:email_address)).to be_blank
    end
  end
end
