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
