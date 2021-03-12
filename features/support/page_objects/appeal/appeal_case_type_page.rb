class AppealCaseTypePage < BasePage
  set_url '/en/steps/appeal/case_type'

  section :content, '#main-content' do
    element :header, 'h1', text: 'What is your appeal about?'
    element :income_tax, 'label', text: %r{Income Tax}
    element :vat, 'label', text: 'Value Added Tax (VAT)'
    element :capital_gains_option, '.govuk-label', text: 'Capital Gains Tax'
    element :other_option, '.govuk-label', text: 'Other type of tax, appeal or application'
    section :error, '.govuk-error-summary' do
      element :error_heading, '#error-summary-title', text: 'There is a problem'
      element :error_link, 'a', text: 'Select what your appeal is about'
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
