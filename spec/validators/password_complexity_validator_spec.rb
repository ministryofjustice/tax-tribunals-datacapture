require 'spec_helper'

class ModelWithPassword
  include ActiveModel::Validations
  validates_with PasswordComplexityValidator

  attr_reader :password

  def initialize(password)
    @password = password
  end
end

RSpec.describe PasswordComplexityValidator do
  describe "PATTERNS" do
    it 'is a Hash' do
      expect(PasswordComplexityValidator::PATTERNS).to be_a(Hash)
    end
  end

  describe "validate" do
    context 'strong password' do
      it 'is valid' do
        model = ModelWithPassword.new('jF3p2#W!b8X')
        expect(model).to be_valid
      end
    end

    context 'weak password' do
      let(:model) { ModelWithPassword.new('helloworld') }

      it 'is not valid' do
        expect(model).to_not be_valid
      end

      it 'has error messages' do
        model.valid?
        err_msg = 'Enter a password that has at least one number (0-9)'
        expect(model.errors[:password]).to include(err_msg)
      end
    end
  end
end
