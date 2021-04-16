Given("I am on the what support page") do
  navigate_to_what_support_page
  expect(what_support_page.content).to have_header
end

Then("I should see the what support blank error") do
  expect(what_support_page.content.error_summary).to have_nothing_selected_error
end

When("I click all of the what support checkboxes") do
  what_support_page.content.language_interpreter_checkbox.click
  what_support_page.content.sign_language_checkbox.click
  what_support_page.content.hearing_loop_checkbox.click
  what_support_page.content.accessible_hearing_room_checkbox.click
  what_support_page.content.other_support_checkbox.click
end

Then("I should see three what support blank text errors") do
  expect(what_support_page.content.error_summary).to have_blank_language_interpreter_error
  expect(what_support_page.content.error_summary).to have_blank_sign_language_error
  expect(what_support_page.content.error_summary).to have_blank_other_support_error
end

When("I fill in the three what support textboxes and submit") do
  what_support_page.content.language_interpreter_textbox.find(:xpath, 'option[2]').select_option
  what_support_page.content.sign_language_textbox.find(:xpath, 'option[2]').select_option
  what_support_page.content.other_support_textarea.set 'text'
  continue_or_save_continue
end

Then("I should be on the letter upload page") do
  expect(letter_upload_type_page.content).to have_header
end
