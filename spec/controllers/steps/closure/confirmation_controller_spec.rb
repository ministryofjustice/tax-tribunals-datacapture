require 'rails_helper'

RSpec.describe Steps::Closure::ConfirmationController, type: :controller do
  it_behaves_like 'an end point step controller'
  it_behaves_like 'an end of navigation controller'
end
