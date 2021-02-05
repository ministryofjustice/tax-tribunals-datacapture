class PenaltyAndTaxAmountsPage < BasePage
  set_url '/steps/appeal/penalty_and_tax_amounts'

  section :content, '#main-content' do
    element :header, 'h1', text: 'What are the tax and penalty or surcharge amounts under dispute?'
    element :amount_under_dispute_input, "input[name='steps_appeal_penalty_and_tax_amounts_form[tax_amount]']"
    element :penalty_or_surchange_input, "input[name='steps_appeal_penalty_and_tax_amounts_form[penalty_amount]']"
    section :error_summary, '.govuk-error-summary__body' do
      element :enter_penalty_amount_error, 'a', text: "Enter the penalty amount (or 'unknown' if you don't have it)"
      element :enter_tax_amount_error, 'a', text: "Enter the tax amount (or 'unknown' if you don't have it)"
    end
  end

  def valid_submission
    content.amount_under_dispute_input.set '100'
    content.penalty_or_surchange_input.set '100'
    continue_or_save_continue
  end
end
