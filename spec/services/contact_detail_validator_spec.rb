require 'rails_helper'

RSpec.describe ContactDetailValidator do
  describe '#contact_detail' do
    subject { described_class.new(' ABC123 ') }

    it 'strips leading and trailing whitespace from input' do
      expect(subject.contact_detail).to eq('ABC123')
    end
  end

  describe '#valid_postcode?' do
    let(:postcode) { 'W1A 2AB' }
    let(:validator) { double }

    it 'processes the postcode with an external validator' do
      expect(validator).to receive(:full_valid?)
      expect(UKPostcode).to receive(:parse).with(postcode).and_return(validator)
      described_class.valid_postcode?(postcode)
    end
  end

  describe '#valid_email?' do
    let(:email) { 'test@example.com' }

    it 'processes email with an external validator' do
      expect(EmailValidator).to receive(:valid?).with(email)
      described_class.valid_email?(email)
    end
  end

  describe '#valid_phone?' do
    let(:phone) { '02033343555' }

    it 'processes phone number with an external validator' do
      expect(Phonelib).to receive(:valid_for_country?).with(phone, :gb)
      described_class.valid_phone?(phone)
    end
  end
end
