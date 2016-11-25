require 'rails_helper'

RSpec.describe Steps::<%= task_name.classify %>::<%= step_name.classify %>Controller, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::<%= task_name.classify %>::<%= step_name.classify %>Form, <%= task_name.classify %>DecisionTree
end
