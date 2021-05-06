class HomePage < BasePage
  set_url '/' + ENV['TEST_LOCALE'] + '/'

  section :content, '#main-content' do
    element :header, 'h1', text: I18n.t('home.index.heading')
    element :appeal_link, 'a', text: I18n.t('home.index.link_titles.appeal')
    element :close_enquiry_link, 'a', text: I18n.t('home.index.link_titles.close')
    element :return, 'a', text: I18n.t('home.index.link_titles.home_login')
    element :view_guidance_link, 'a', text: I18n.t('home.index.link_titles.guidance')
    element :time_information_tax, 'p', text: '(30 minutes to complete)'
    element :time_information_enquiry, 'p', text: '(15 minutes to complete)'
  end

  def appeal
    content.appeal_link.click
  end

  def close_enquiry
    content.close_enquiry_link.click
  end

  def return
    content.return.click
  end

  def view_guidance
    content.view_guidance_link.click
  end
end
