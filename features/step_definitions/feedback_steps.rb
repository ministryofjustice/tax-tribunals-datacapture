And(/^I am on the feedback page$/) do
  home_page.load_page
  feedback_tab = window_opened_by { click_link 'Report a problem' }
  within_window feedback_tab do
    expect(feedback_page).to be_displayed
    expect(feedback_page.content).to have_header
    expect(feedback_page.content).to have_note
  end
end

And(/^I successfully submit my feedback$/) do
  feedback_page.submit_feedback
end

When(/^I submit a blank form$/) do
  feedback_page.submit_blank_form
end

Then(/^I should see error messages for the mandatory fields$/) do
  within_window windows.last do
    expect(feedback_page.content).to have_name_error
    expect(feedback_page.content).to have_email_error
    expect(feedback_page.content).to have_multiple_choice_error
    expect(feedback_page.content).to have_text_field_box
  end
end

Then(/^I am taken to a thank you page$/) do
  within_window windows.last do
    expect(thank_you_page).to be_displayed
    expect(thank_you_page.content).to have_header
    expect(thank_you_page.content).to have_contact_via_email
  end
end

Then("when I click continue") do
  within_window windows.last do
    thank_you_page.content.continue_button.click
  end
end

Then("I am taken to the homepage") do
  expect(home_page).to be_displayed
end