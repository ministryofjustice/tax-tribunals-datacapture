require 'rails_helper'

RSpec.feature 'Details', type: :feature do
  before do
    visit_homepage
    complete_cost_task
    complete_lateness_task
    start_task
  end

  scenario 'WIP: Individual-or-company step redirects back to homepage' do
    answer_question 'Is the appeal for an individual or company?', with: 'Individual'
    expect(page).to have_current_path(root_path)
  end
end
