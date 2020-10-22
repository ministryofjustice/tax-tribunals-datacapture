def appeal_page
  @appeal_page ||= AppealPage.new
end

def base_page
  @base_page ||= BasePage.new
end

def case_type_page
  @case_type_page ||= CaseTypePage.new
end

def closure_page
  @closure_page ||= ClosurePage.new
end

def enquiry_details_page
  @enquiry_details_page ||= EnquiryDetailsPage.new
end

def home_page
  @home_page ||= HomePage.new
end

def appeal_home_page
  @appeal_home_page ||= AppealHomePage.new
end

def appeal_case_type_page
  @appeal_case_type_page ||= AppealCaseTypePage.new
end

def appeal_case_type_show_more_page
  @appeal_case_type_show_more_page ||= AppealCaseTypeShowMorePage.new
end

def challenge_decision_page
  @challenge_decision_page ||= ChallengeDecisionPage.new
end

def taxpayer_details_page
  @taxpayer_details_page ||= TaxpayerDetailsPage.new
end

def representative_page
  @representative_page ||= RepresentativePage.new
end

def taxpayer_type_page
  @taxpayer_type_page ||= TaxpayerTypePage.new
end

def user_type_page
  @user_type_page ||= UserTypePage.new
end

def feedback_page
  @feedback_page ||= FeedbackPage.new
end

def thank_you_page
  @thank_you_page ||= ThankYouPage.new
end

def save_appeal_page
  @save_appeal_page ||= SaveAppealPage.new
end

def continue
  base_page.content.continue_button.click
end

def save_and_continue
  base_page.content.save_continue_button.click
end

def save
  base_page.content.save_button.click
end
