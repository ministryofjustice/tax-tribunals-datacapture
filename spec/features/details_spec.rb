require 'rails_helper'

RSpec.feature 'Details', type: :feature do
  before do
    visit_homepage
    complete_cost_task
    complete_lateness_task
    start_task
  end

  scenario 'appeal for an individual' do
    answer_question 'Is the appeal for an individual or company?', with: 'Individual'

    fill_in 'Name (first name and last name)', with: 'Jane Taxpayer'
    fill_in 'Address', with: '123 New Street'
    fill_in 'Postcode', with: 'AB1 2CD'
    fill_in 'Email address', with: 'jane.taxpayer@aol.co.uk'
    fill_in 'Phone number', with: '0118 999 881 999 119 7253'
    continue

    expect(page).to have_current_path(root_path)
  end

  scenario 'appeal for a company' do
    answer_question 'Is the appeal for an individual or company?', with: 'Company'

    fill_in 'Company name', with: 'ACME Ltd'
    fill_in 'Company registration number', with: 'ABC123'
    fill_in 'Company contact person (first name and last name)', with: 'Jane Taxpayer'
    fill_in 'Address', with: '123 New Street'
    fill_in 'Postcode', with: 'AB1 2CD'
    fill_in 'Email address', with: 'jane.taxpayer@aol.co.uk'
    fill_in 'Phone number', with: '0118 999 881 999 119 7253'
    continue

    expect(page).to have_current_path(root_path)
  end
end
