class PenaltyAndTaxAmountsPage < BasePage
  set_url '/en/steps/appeal/penalty_and_tax_amounts'

  section :content, '#main-content' do
    element :header, 'h1', text: I18n.t('steps.appeal.penalty_and_tax_amounts.edit.heading')
    element :amount_under_dispute_input, "input[name='steps_appeal_penalty_and_tax_amounts_form[tax_amount]']"
    element :penalty_or_surchange_input, "input[name='steps_appeal_penalty_and_tax_amounts_form[penalty_amount]']"
    section :error_summary, '.govuk-error-summary__body' do
      element :enter_penalty_amount_error, 'a', text: I18n.t('dictionary.blank_penalty_amount')
      element :enter_tax_amount_error, 'a', text: I18n.t('dictionary.blank_tax_amount')
    end
  end

  def valid_submission
    content.amount_under_dispute_input.set '100'
    content.penalty_or_surchange_input.set '100'
    continue_or_save_continue
  end
end
