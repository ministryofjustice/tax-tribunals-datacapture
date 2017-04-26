require 'rails_helper'

RSpec.describe User, type: :model do

  describe '#last_sign_in_at' do
    specify { expect(described_class.column_names).to include('last_sign_in_at') }
  end
end
