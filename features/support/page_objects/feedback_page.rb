class FeedbackPage < BasePage
  set_url '/surveys/feedback/new'

  section :content, '#content' do
    element :header, 'h1', text: 'Report a problem'
    element :note, 'p', 'Please note: we cannot offer legal advice.'
    element :someone_else_option, '.multiple-choice', text: 'I have difficulty using computers, so someone filled in the online Tax Tribunal application for me'
    element :submit_button, "input[value='Submit']"
    element :name_error, '.error-message', text: 'Please enter a valid name'
    element :email_error, '.error-message', text: 'Please enter a valid email address'
    element :multiple_choice_error, '.error-message', text: 'Please enter an answer'
    element :text_field_box, '.error-message', text: 'Please enter some text'
  end

  def submit_feedback
    within_window windows.last do
      p current_url
      fill_in 'Name', with: 'John Smith'
      fill_in 'Email', with: 'test@test.com'
      feedback_page.content.someone_else_option.click
      fill_in 'Describe what you would like to report', with: 'I need help with my appeal'
      feedback_page.content.submit_button.click
    end
  end

  def submit_blank_form
    within_window windows.last do
      feedback_page.content.submit_button.click
    end
  end
end