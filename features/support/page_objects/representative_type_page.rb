class RepresentativeTypePage < BasePage
  set_url '/' + ENV['TEST_LOCALE'] + '/steps/details/representative_type'

  section :content, '#main-content' do
    element :header, 'h1', text: I18n.t('helpers.fieldset.steps_details_representative_type_form.representative_type_html')
    element :individual, 'label', text: I18n.t('steps.details.representative_type.edit.individual')
    element :company, 'label', text: I18n.t('steps.details.representative_type.edit.company')
    element :other, 'label', text: I18n.t('steps.details.representative_type.edit.other')
    section :error, '.govuk-error-summary' do
      element :error_heading, '#error-summary-title', text: I18n.t('errors.error_summary.heading')
    end
  end

  def submit_individual
    content.individual.click
    continue_or_save_continue
  end

  def submit_company
    content.company.click
    continue_or_save_continue
  end

  def submit_other
    content.other.click
    continue_or_save_continue
  end

end
