class AppealPage < BasePage
  set_url '/' + ENV['TEST_LOCALE'] + '/appeal'

  section :content, '#main-content' do
    element :header, 'h2', text: I18n.t('appeal_home.index.heading')
    element :continue_button, 'a', text: I18n.t('appeal_home.index.continue')
  end

  def continue
    content.continue_button.click
  end
end
