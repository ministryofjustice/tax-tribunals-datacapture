require 'rails_helper'

RSpec.describe Steps::Appeal::StartController, type: :controller do
  it_behaves_like 'a starting point step controller', intent: Intent::TAX_APPEAL
end
