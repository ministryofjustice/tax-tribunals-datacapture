require 'rails_helper'

RSpec.describe Steps::Appeal::DetermineCostController, type: :controller do
  let!(:tribunal_case) { instance_double(TribunalCase, lodgement_fee: 999_99) }

  it_behaves_like 'an end point step controller'
end
