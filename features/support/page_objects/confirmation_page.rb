class ConfirmationPage < BasePage
  set_url_matcher %r{/en/confirmation$}

  section :content, '#main-content' do
    element :case_submitted_header, 'h1', text: I18n.t('dictionary.CYA_CONFIRMATION.confirmation.show.page_title')
    element :finish_button,"input[value='"+ I18n.t('dictionary.START_FINISH.finish') +"']"
  end

  def finish
    content.finish_button.click
  end
end
