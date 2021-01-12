Given("I am on the closure case type page") do
  go_to_closure_case_type_page
end

Then("I should see that I can only close one of the listed options") do
  expect(case_type_page.content).to have_one_on_list
end

When("I submit that it is a personal return") do
  case_type_page.submit_personal_return
end
