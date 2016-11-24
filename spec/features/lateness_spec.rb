require 'rails_helper'

RSpec.feature 'Lateness', type: :feature do
  before do
    visit_homepage
    complete_cost_task
    start_task
  end

  scenario 'taxpayer is in time' do
    answer_question "Do you think you're in time to appeal to the tax tribunal?", with: 'Yes, I am in time'

    expect(page).to have_current_path(root_path)
  end

  scenario 'taxpayer is definitely late' do
    answer_question "Do you think you're in time to appeal to the tax tribunal?", with: 'No, I am late'

    fill_in 'Reason(s) for late appeal', with: 'I am really sorry'
    continue

    expect(page).to have_current_path(root_path)
  end

  scenario 'taxpayer is unsure' do
    answer_question "Do you think you're in time to appeal to the tax tribunal?", with: "I'm not sure"

    fill_in 'Reason(s) for late appeal', with: 'I have no idea'
    continue

    expect(page).to have_current_path(root_path)
  end
end
