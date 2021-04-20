class TaxAmountPage < BasePage
  set_url '/en/steps/appeal/tax_amount'

  section :content, '#main-content' do
    element :header, 'h1', text: I18n.t('steps.appeal.tax_amount.edit.heading')
    element :textbox, "input[name='steps_appeal_tax_amount_form[tax_amount]']"
    section :error_summary, '.govuk-error-summary__body' do
      element :enter_tax_amount_error, 'a', text: I18n.t('dictionary.blank_tax_amount')
    end
  end

  def valid_submission
    content.textbox.set '100'
    continue_or_save_continue
  end
end
