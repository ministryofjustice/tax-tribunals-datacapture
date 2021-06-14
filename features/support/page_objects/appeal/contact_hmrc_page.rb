class ContactHmrcPage < BasePage
  set_url '/' + ENV['TEST_LOCALE'] + '/steps/hardship/hardship_contact_hmrc'

  section :content, '#main-content' do
    element :header, 'h1', text: I18n.t('steps.hardship.hardship_contact_hmrc.edit.heading')
    element :contact_hmrc, 'input[type="submit"]', text: I18n.t('steps.hardship_contact_hmrc.edit.contact_hmrc')
  end
end
