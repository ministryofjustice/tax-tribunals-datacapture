require 'rails_helper'

RSpec.describe Steps::Closure::EnquiryDetailsController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Closure::EnquiryDetailsForm, ClosureDecisionTree
end
