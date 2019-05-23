def base_page
  @base_page ||= BasePage.new
end

def home_page
  @home_page ||= HomePage.new
end

def closure_page
  @closure_page ||= ClosurePage.new
end

def case_type_page
  @case_type_page ||= CaseTypePage.new
end

def continue
  base_page.content.continue_button.click
end

def save_and_continue
  base_page.content.save_continue_button.click
end
