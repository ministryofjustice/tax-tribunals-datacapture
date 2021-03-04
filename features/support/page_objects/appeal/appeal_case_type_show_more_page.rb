class AppealCaseTypeShowMorePage < BasePage
  set_url '/en/steps/appeal/case_type_show_more'

  section :content, '#main-content' do
    element :header, 'h1', text: 'What is your appeal about?'
    element :aggregates_levy_option,'.govuk-label', text: 'Aggregates Levy'
    element :none_of_above_option,'.govuk-label', text: 'None of the above'
    element :none_of_above_answer_box, '#steps-appeal-case-type-show-more-form-case-type-other-value-field'
    section :error, '.govuk-error-summary' do
      element :answer_error_heading, '#error-summary-title', text: 'There is a problem'
      element :answer_error_link, 'a', text: 'Please enter an answer'
    end
  end

  def submit_aggregates_levy_option
    content.aggregates_levy_option.click
    continue_or_save_continue
  end
end
