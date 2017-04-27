require 'rails_helper'

RSpec.describe Steps::Closure::StartController, type: :controller do
  it_behaves_like 'a starting point step controller', intent: Intent::CLOSE_ENQUIRY
end
