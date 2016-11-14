require 'rails_helper'

def start_application
  visit '/'
  click_link 'Start now'
end

def answer_question(question, with:)
  within_fieldset(question) do
    choose(with)
  end
  click_button 'Continue'
end

def expect_amount_on(page, gbp: nil)
  expect(page).to have_text("#{I18n.t('steps.determine_cost.show.fee_label')} £#{gbp}")
end
