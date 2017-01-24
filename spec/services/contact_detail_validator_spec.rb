require 'rails_helper'

RSpec.describe ContactDetailValidator do
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
end
