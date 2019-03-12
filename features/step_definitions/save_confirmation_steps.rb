Then(/^I should be taken to case saved page$/) do
  expect(save_confirmation_page.content).to have_header
  expect(current_url).to include '/users/registration/save_confirmation'
end
