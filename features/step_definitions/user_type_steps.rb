Given("I am on the user type page") do
  go_to_closure_user_type_page
end

When("I submit that I am the tax payer making the application") do
  submit_yes
end

When("I submit that I am not the tax payer making the application") do
  submit_no
end