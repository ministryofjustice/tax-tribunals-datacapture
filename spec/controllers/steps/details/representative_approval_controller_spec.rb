require 'rails_helper'

RSpec.describe Steps::Details::RepresentativeApprovalController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Details::RepresentativeApprovalForm, DetailsDecisionTree
end
