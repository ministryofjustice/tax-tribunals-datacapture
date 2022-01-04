class RepresentativeProfessionalPage < BasePage
  set_url '/' + ENV['TEST_LOCALE'] + '/steps/details/representative_professional_status'

  section :content, '#main-content' do
    element :representatives_header, 'h1', text: I18n.t('steps.details.representative_professional_status.edit.heading.as_representative')
    element :individuals_header, 'h1', text: I18n.t('steps.details.representative_professional_status.edit.heading.as_taxpayer')
    element :practising_solicitor_option, 'label', text: I18n.t('steps.details.representative_professional_status.edit.practising_solicitor_option')
    section :error, '.govuk-error-summary' do
      element :error_heading, '#error-summary-title', text: I18n.t('errors.error_summary.heading')
    end
  end

  def submit_practising_solicitor
    content.practising_solicitor_option.click
    continue_or_save_continue
  end
end
