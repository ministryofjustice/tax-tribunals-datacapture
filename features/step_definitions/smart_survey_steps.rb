Given("that I'm on the home page and want to give feedback") do
  home_page.load_page
end

Then("there should be a smart survey link at the top of the home page") do
  expect(home_page).to have_link('Report a problem', href: 'https://www.smartsurvey.co.uk/s/TTFeed20/')
end
