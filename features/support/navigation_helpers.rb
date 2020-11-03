def go_to_case_type_page
  home_page.load_page
  expect(home_page).to be_displayed
  home_page.close_enquiry
  expect(closure_page).to be_displayed
  closure_page.continue
end

def go_to_closure_page
  home_page.load_page
  expect(home_page).to be_displayed
  home_page.close_enquiry
end

def go_to_taxpayer_details_page
  home_page.load_page
  expect(home_page).to be_displayed
  home_page.close_enquiry
  expect(closure_page).to be_displayed
  closure_page.continue
  expect(case_type_page).to be_displayed
  case_type_page.submit_personal_return
  expect(user_type_page).to be_displayed
  user_type_page.submit_yes
  expect(taxpayer_type_page).to be_displayed
  taxpayer_type_page.submit_individual
end

def go_to_taxpayer_type_page
  home_page.load_page
  home_page.close_enquiry
  closure_page.continue
  case_type_page.submit_personal_return
  user_type_page.submit_yes
end

def go_to_user_type_page
  home_page.load_page
  home_page.close_enquiry
  closure_page.continue
  case_type_page.submit_personal_return
end

def go_to_representative_page
  home_page.load_page
  home_page.close_enquiry
  closure_page.continue
  case_type_page.submit_personal_return
  user_type_page.submit_yes
  base_page.submit_individual
  taxpayer_details_page.submit_taxpayer_details
end
