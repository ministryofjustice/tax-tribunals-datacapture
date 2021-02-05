class PenaltyAmountPage < BasePage
  set_url '/steps/appeal/penalty_amount'

  section :content, '#main-content' do
    element :header, 'h1', text: 'How much is the penalty or surcharge you are disputing?'
    element :one_hundred_or_less_option, 'label', text: '£100 or less'
    element :one_hundred_to_twenty_thousand_option, 'label', text: 'over £100 – £20,000'
    element :penalty_amount_input, "input[name='steps_appeal_penalty_amount_form[penalty_amount]']"
    section :error_summary, '.govuk-error-summary__body' do
      element :enter_penalty_error, 'a', text: 'Enter the penalty amount (or \'unknown\' if you don\'t have it)'
      element :select_option_error, 'a', text: 'Select a penalty or surcharge amount'
    end
  end

  def submit_100_or_less
    content.one_hundred_or_less_option.click
    continue_or_save_continue
  end

  def submit_invalid_100_to_20000
    content.one_hundred_to_twenty_thousand_option.click
    continue_or_save_continue
  end

  def submit_valid_100_to_20000
    content.one_hundred_to_twenty_thousand_option.click
    content.penalty_amount_input.set '200'
    continue_or_save_continue
  end
end
