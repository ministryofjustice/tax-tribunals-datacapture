class AppealCaseTypeShowMorePage < BasePage
  set_url '/' + ENV['TEST_LOCALE'] + '/steps/appeal/case_type_show_more'

  section :content, '#main-content' do
    element :header, 'h1', text: I18n.t('dictionary.CASE_TYPE_QUESTION.heading')
    element :aggregates_levy_option,'.govuk-label', text: I18n.t('check_answers.case_type.answers.aggregates_levy')
    element :none_of_above_option,'.govuk-label', text: I18n.t('helpers.label.steps_details_representative_professional_status_form.representative_professional_status_options.other_html')
    element :none_of_above_answer_box, '#steps-appeal-case-type-show-more-form-case-type-other-value-field'
    section :error, '.govuk-error-summary' do
      element :answer_error_heading, '#error-summary-title', text: I18n.t('errors.error_summary.heading')
      element :answer_error_link, 'a', text: I18n.t('errors.messages.blank')
    end
  end

  def submit_aggregates_levy_option
    content.aggregates_levy_option.click
    continue_or_save_continue
  end
end
