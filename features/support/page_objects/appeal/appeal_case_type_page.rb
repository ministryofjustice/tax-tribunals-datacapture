class AppealCaseTypePage < BasePage
  set_url '/' + ENV['TEST_LOCALE'] + '/steps/appeal/case_type'

  section :content, '#main-content' do
    element :header, 'h1', text: I18n.t('dictionary.CASE_TYPE_QUESTION.heading')
    element :income_tax, 'label', text: I18n.t('check_answers.case_type.answers.income_tax')
    element :vat, 'label', text: I18n.t('check_answers.case_type.answers.vat')
    element :capital_gains_option, '.govuk-label', text: I18n.t('en.check_answers.case_type.answers.capital_gains_tax')
    element :other_option, '.govuk-label', text: I18n.t('check_answers.case_type.answers.other_tax')
    section :error, '.govuk-error-summary' do
      element :error_heading, '#error-summary-title', text: I18n.t('errors.error_summary.heading')
      element :error_link, 'a', text: I18n.t('activemodel.errors.models.steps/appeal/case_type_form.attributes.case_type.inclusion')
    end
  end

  def submit_income_tax
    content.income_tax.click
    continue
  end

  def submit_vat
    content.vat.click
    continue
  end

  def submit_other
    content.other_option.click
    continue
  end

  def submit_capital_gains_option
    content.capital_gains_option.click
    continue
  end
end
