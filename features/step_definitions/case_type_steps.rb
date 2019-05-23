Then("I am taken to the case type case") do
  expect(case_type_page).to be_displayed
  expect(case_type_page.content).to have_header
end
