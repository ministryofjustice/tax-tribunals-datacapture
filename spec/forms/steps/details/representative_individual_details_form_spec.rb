require 'spec_helper'

RSpec.describe Steps::Details::RepresentativeIndividualDetailsForm do
  it_behaves_like 'a contactable entity form',
    entity_type: :representative,
    additional_fields: [
      :representative_individual_first_name,
      :representative_individual_last_name
    ]

  describe '#name_fields' do
    specify { expect(subject.name_fields).to eq([:representative_individual_first_name, :representative_individual_last_name]) }
  end

  describe '#show_fao?' do
    specify { expect(subject.show_fao?).to eq(false) }
  end

  describe '#show_registration_number?' do
    specify { expect(subject.show_registration_number?).to eq(false) }
  end
end
