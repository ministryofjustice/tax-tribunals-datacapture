require 'rails_helper'

RSpec.feature 'Cost decisions', :type => :feature do
  before { start_application }

  scenario 'Challenged income tax appeal' do
    answer_question 'Did you challenge the decision with HMRC first?', with: 'Yes'
    answer_question 'What is your appeal about?', with: 'Income Tax'

    expect(page).to have_text('To submit an appeal you will have to pay')
  end

  scenario 'Unchallenged income tax appeal' do
    answer_question 'Did you challenge the decision with HMRC first?', with: 'No'
    answer_question 'What is your appeal about?', with: 'Income Tax'

    expect(page).to have_text('You must challenge HMRC before you can appeal')
  end
end
