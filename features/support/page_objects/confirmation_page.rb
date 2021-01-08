class ConfirmationPage < BasePage
  set_url_matcher %r{/confirmation$}

  section :content, '#main-content' do
    element :case_submitted_header, 'h1', text: 'Case submitted'
  end
end
