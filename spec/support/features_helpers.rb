require 'spec_helper'

def visit_homepage
  visit '/'
end

def start_task
  click_link 'Start'
  click_link 'Continue'
end

def answer_question(question, with:)
  within_fieldset(question) do
    choose(with)
  end
  continue
end

def continue
  click_button 'Continue'
end

def complete_cost_task
  start_task
  answer_question 'Did you challenge the decision with HMRC first?', with: 'No'
  answer_question 'What is your appeal about?', with: 'Closure notice'
  click_link 'Continue'
end

def complete_lateness_task
  start_task
  answer_question "Do you think you're in time to appeal to the tax tribunal?", with: 'Yes, I am in time'
end

def expect_amount_on(page, gbp: nil)
  expect(page).to have_text("#{I18n.t('steps.cost.determine_cost.show.fee_label')} £#{gbp}")
end
