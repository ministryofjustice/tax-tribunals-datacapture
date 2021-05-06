class ClosurePage < BasePage
  set_url '/' + ENV['TEST_LOCALE'] + '/closure'

  section :content, '#main-content' do
    element :header, 'h1', text: I18n.t('closure_home.index.heading')
    element :continue_button, 'a', text: I18n.t('closure_home.index.continue')
  end

  def continue
    content.continue_button.click
  end
end
