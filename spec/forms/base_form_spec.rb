require 'rails_helper'

RSpec.describe BaseForm do
  let(:tribunal_case) { double('Tribunal Case') }
  subject { described_class.new(tribunal_case) }

  describe '#persisted?' do
    it 'always returns false' do
      expect(subject.persisted?).to eq(false)
    end
  end
end
