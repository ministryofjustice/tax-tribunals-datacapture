class EuExitPage < BasePage
  set_url '/' + ENV['TEST_LOCALE'] + '/steps/details/eu_exit'

  section :content, '#main-content' do
    element :header, 'h1', text: I18n.t('steps.details.eu_exit.edit.heading')
  end
end
