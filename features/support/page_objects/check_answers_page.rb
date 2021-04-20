class CheckAnswersPage < BasePage
  set_url '/en/steps/closure/check_answers'

  section :content, '#main-content' do
    element :header, 'h1', text: I18n.t('dictionary.CYA_CONFIRMATION.check_answers.show.page_title')
    element :application_type_heading, 'h2', text: I18n.t('check_answers.sections.closure_type')
    element :taxpayer_details_heading, 'h2', text: I18n.t('check_answers.sections.taxpayer')
    element :enquiry_details_heading, 'h2', text: I18n.t('check_answers.sections.closure_details')
  end
end
