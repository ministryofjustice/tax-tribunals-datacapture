require 'rails_helper'

RSpec.feature 'Cost decisions', :type => :feature do
  before { start_application }

  scenario 'Challenged income tax appeal' do
    answer_question 'Did you challenge the decision with HMRC first?', with: 'Yes'
    answer_question 'What is your appeal about?', with: 'Income Tax'

    expect(page).to have_text('To submit an appeal you will have to pay')
  end

  context 'unchallenged' do
    before do
      answer_question 'Did you challenge the decision with HMRC first?', with: 'No'
    end

    scenario 'income tax appeal' do
      answer_question 'What is your appeal about?', with: 'Income Tax'

      expect(page).to have_text('You must challenge HMRC before you can appeal')
    end

    context 'VAT appeal' do
      before do
        answer_question 'What is your appeal about?', with: 'Value Added Tax (VAT)'
      end

      scenario 'on the basis of amount of tax owed' do
        answer_question 'What is your dispute about?', with: 'Amount of tax owed'

        expect(page).to have_text('To submit an appeal you will have to pay')
      end

      scenario 'on the basis of late return/payment' do
        answer_question 'What is your dispute about?', with: 'Late return or payment'
        answer_question 'What is the penalty or surcharge amount?', with: '£100 or less'

        expect(page).to have_text('To submit an appeal you will have to pay')
      end
    end

    scenario 'closure notice appeal' do
      answer_question 'What is your appeal about?', with: 'Closure notice'

      expect(page).to have_text('To submit an appeal you will have to pay')
    end

    scenario 'information notice appeal' do
      answer_question 'What is your appeal about?', with: 'Information notice'

      expect(page).to have_text('To submit an appeal you will have to pay')
    end

    scenario 'request for permission to review' do
      answer_question 'What is your appeal about?', with: 'Request permission for a review'

      expect(page).to have_text('To submit an appeal you will have to pay')
    end

    scenario 'APN penalty appeal' do
      answer_question 'What is your appeal about?', with: 'Advance Payment Notice (APN) penalty'

      expect(page).to have_text('To submit an appeal you will have to pay')
    end

    scenario 'inaccurate return appeal' do
      answer_question 'What is your appeal about?', with: 'Inaccurate return'

      expect(page).to have_text('To submit an appeal you will have to pay')
    end
  end
end
