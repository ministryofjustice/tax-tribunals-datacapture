class ClosureCaseTypePage < BasePage
  set_url '/en/steps/closure/case_type'

  section :content, '#main-content' do
    element :header, 'h1', text: I18n.t('check_answers.closure_case_type.question')
    element :one_on_list, '.govuk-hint'
    element :personal_return, 'label', text: I18n.t('check_answers.closure_case_type.answers.personal_return')
  end

  def submit_personal_return
    content.personal_return.click
    continue_or_save_continue
  end
end
