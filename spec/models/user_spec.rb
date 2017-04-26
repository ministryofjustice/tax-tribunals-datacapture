require 'rails_helper'

RSpec.describe User, type: :model do

  describe '#last_sign_in_at' do
    specify { expect(described_class.column_names).to include('last_sign_in_at') }
  end

  describe '.purge!' do
    let(:user_class) { class_double(User) }

    around do |example|
      travel_to(Time.parse('2017-04-30')) do
        example.run
      end
    end

    it 'picks records equal to or older than the passed-in date' do
      expect(described_class).to receive(:where).with(
        ["last_sign_in_at <= :date OR (created_at <= :date AND last_sign_in_at IS NULL)", date: 30.days.ago]
      ).and_return(user_class.as_null_object)

      described_class.purge!(30.days.ago)
    end

    it 'calls #destroy_all on the records it finds' do
      allow(described_class).to receive(:where).and_return(user_class)
      expect(user_class).to receive(:destroy_all)
      described_class.purge!(30.days.ago)
    end
  end
end
