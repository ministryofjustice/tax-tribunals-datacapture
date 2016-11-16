require 'rails_helper'

RSpec.feature 'Cost decisions', :type => :feature do
  before do
    start_application
    start_task
  end

  scenario 'unchallenged income tax appeal' do
    answer_question 'Did you challenge the decision with HMRC first?', with: 'No'
    answer_question 'What is your appeal about?', with: 'Income Tax'

    expect(page).to have_text('You must challenge HMRC before you can appeal')
  end

  scenario 'Challenged income tax appeal on the basis of amount of tax owed' do
    answer_question 'Did you challenge the decision with HMRC first?', with: 'Yes'
    answer_question 'What is your appeal about?', with: 'Income Tax'
    answer_question 'What is your dispute about?', with: 'Amount of tax owed'

    expect_amount_on page, gbp: 200
  end

  scenario 'Challenged income tax appeal on the basis of amount of late return/payment (< £101)' do
    answer_question 'Did you challenge the decision with HMRC first?', with: 'Yes'
    answer_question 'What is your appeal about?', with: 'Income Tax'
    answer_question 'What is your dispute about?', with: 'Late return or payment'
    answer_question 'What is the penalty or surcharge amount?', with: '£100 or less'

    expect_amount_on page, gbp: 20
  end

  scenario 'Challenged income tax appeal on the basis of amount of late return/payment (£101 to £20,000)' do
    answer_question 'Did you challenge the decision with HMRC first?', with: 'Yes'
    answer_question 'What is your appeal about?', with: 'Income Tax'
    answer_question 'What is your dispute about?', with: 'Late return or payment'
    answer_question 'What is the penalty or surcharge amount?', with: '£101 – £20,000'

    expect_amount_on page, gbp: 50
  end

  scenario 'Challenged income tax appeal on the basis of amount of late return/payment (> £20,000)' do
    answer_question 'Did you challenge the decision with HMRC first?', with: 'Yes'
    answer_question 'What is your appeal about?', with: 'Income Tax'
    answer_question 'What is your dispute about?', with: 'Late return or payment'
    answer_question 'What is the penalty or surcharge amount?', with: '£20,001 or more'

    expect_amount_on page, gbp: 200
  end

  scenario 'unchallenged VAT appeal on the basis of amount of tax owed' do
    answer_question 'Did you challenge the decision with HMRC first?', with: 'No'
    answer_question 'What is your appeal about?', with: 'Value Added Tax (VAT)'
    answer_question 'What is your dispute about?', with: 'Amount of tax owed'

    expect_amount_on page, gbp: 200
  end

  scenario 'unchallenged VAT appeal on the basis of late return/payment' do
    answer_question 'Did you challenge the decision with HMRC first?', with: 'No'
    answer_question 'What is your appeal about?', with: 'Value Added Tax (VAT)'
    answer_question 'What is your dispute about?', with: 'Late return or payment'
    answer_question 'What is the penalty or surcharge amount?', with: '£100 or less'

    expect_amount_on page, gbp: 20
  end

  scenario 'closure notice appeal' do
    answer_question 'Did you challenge the decision with HMRC first?', with: 'No'
    answer_question 'What is your appeal about?', with: 'Closure notice'

    expect_amount_on page, gbp: 50
  end

  scenario 'information notice appeal' do
    answer_question 'Did you challenge the decision with HMRC first?', with: 'No'
    answer_question 'What is your appeal about?', with: 'Information notice'

    expect_amount_on page, gbp: 50
  end

  scenario 'request for permission to review' do
    answer_question 'Did you challenge the decision with HMRC first?', with: 'No'
    answer_question 'What is your appeal about?', with: 'Request permission for a review'

    expect_amount_on page, gbp: 50
  end

  scenario 'APN penalty appeal' do
    answer_question 'Did you challenge the decision with HMRC first?', with: 'No'
    answer_question 'What is your appeal about?', with: 'Advance Payment Notice (APN) penalty'

    expect_amount_on page, gbp: 50
  end

  scenario 'inaccurate return appeal' do
    answer_question 'Did you challenge the decision with HMRC first?', with: 'No'
    answer_question 'What is your appeal about?', with: 'Inaccurate return'

    expect_amount_on page, gbp: 50
  end
end
