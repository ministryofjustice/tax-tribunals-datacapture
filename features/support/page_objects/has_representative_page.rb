class HasRepresentativePage < BasePage
  set_url '/' + ENV['TEST_LOCALE'] + '/steps/details/has_representative'

  section :content, '#main-content' do
    element :header, 'h1', text: I18n.t('steps.details.has_representative.edit.heading')
    element :representative, 'p', text: I18n.t('steps.details.has_representative.edit.lead_text')
    section :error, '.govuk-error-summary' do
      element :error_heading, '#error-summary-title', text: I18n.t('errors.error_summary.heading')
    end
    end
  end
