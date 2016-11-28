require 'rails_helper'

RSpec.describe Steps::<%= task_name.camelize %>::<%= step_name.camelize %>Controller, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::<%= task_name.camelize %>::<%= step_name.camelize %>Form, <%= task_name.camelize %>DecisionTree
end
