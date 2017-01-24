require 'rails_helper'

RSpec.describe ContactDetailValidator do
  describe '#valid_postcode?' do
    subject { described_class.valid_postcode?(postcode) }

    context 'a valid postcode' do
      let(:postcode) { 'W1A 2AB' }
      specify { is_expected.to be_truthy }
    end

    context 'a valid postcode (not case sensitive)' do
      let(:postcode) { 'w1A 2aB' }
      specify { is_expected.to be_truthy }
    end

    context 'a valid postcode (without internal spaces)' do
      let(:postcode) { 'W1A2AB' }
      specify { is_expected.to be_truthy }
    end

    context 'a valid postcode with leading spaces' do
      let(:postcode) { ' W1A 2AB' }
      specify { is_expected.to be_truthy }
    end

    context 'a valid postcode with trailing spaces' do
      let(:postcode) { 'W1A 2AB ' }
      specify { is_expected.to be_truthy }
    end

    context 'a mangled postcode' do
      let(:postcode) { 'W1A 2 A B' }
      specify { is_expected.to be_falsey}
    end

    context 'partial postcode' do
      let(:postcode) { 'W1A' }
      specify { is_expected.to be_falsey }
    end

    context 'something that looks like a postcode' do
      let(:postcode) { 'X1Z 1ZZ' }
      specify { is_expected.to be_falsey }
    end

    context 'something other than a postcode' do
      let(:postcode) { '118 118' }
      specify { is_expected.to be_falsey }
    end
  end

  describe '#valid_email?' do
    subject { described_class.valid_email?(email) }

    context "a 'typical' email" do
      let(:email) { 'test@example.com' }
      specify { is_expected.to be_truthy }
    end

    context "a 'typical' email with leading spaces" do
      let(:email) { ' test@example.com' }
      specify { is_expected.to be_truthy }
    end

    context "a 'typical' email with trailing spaces" do
      let(:email) { 'test@example.com ' }
      specify { is_expected.to be_truthy }
    end

    context "a mangled 'typical' email" do
      let(:email) { 'test@examp le .com ' }
      specify { is_expected.to be_falsey}
    end

    context 'a bad email' do
      let(:email) { 'x@y.z' }
      specify { is_expected.to be_falsey }
    end

    context 'something other than an email' do
      let(:email) { 'W1A 1AA' }
      specify { is_expected.to be_falsey }
    end
  end

  describe '#valid_phone?' do
    subject { described_class.valid_phone?(phone) }

    # 'Valid' in the sense of a valid format. Other examples use the official
    # MoJ landline number.
    context 'a valid mobile' do
      let(:phone) { '07766554433' }
      specify { is_expected.to be_truthy }
    end

    context 'a valid landline' do
      let(:phone) { '02033343555' }
      specify { is_expected.to be_truthy }
    end

    context 'a valid landline with internal spacing' do
      let(:phone) { '020 3334 3555' }
      specify { is_expected.to be_truthy }
    end

    context 'a valid phone with a country code' do
      let(:phone) { '+44 20 3334 3555' }
      specify { is_expected.to be_truthy }
    end

    context 'a valid phone with leading spaces' do
      let(:phone) { ' 02033343555' }
      specify { is_expected.to be_truthy }
    end

    context 'a valid phone with trailing spaces' do
      let(:phone) { '02033343555 ' }
      specify { is_expected.to be_truthy }
    end

    context 'a valid phone with trailing spaces' do
      let(:phone) { '02033343555 ' }
      specify { is_expected.to be_truthy }
    end

    context 'an invalid phone' do
      let(:phone) { '12033343555 ' }
      specify { is_expected.to be_falsey }
    end

    context 'something that is not a phone at all' do
      let(:phone) { 'test@example.com' }
      specify { is_expected.to be_falsey }
    end
  end
end
