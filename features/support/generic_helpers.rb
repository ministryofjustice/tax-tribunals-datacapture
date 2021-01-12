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

def login_page
  @login_page ||= LoginPage.new
end

def challenge_decision_page
  @challenge_decision_page ||= ChallengeDecisionPage.new
end

def challenge_decision_status_page
  @challenge_decision_status_page ||= ChallengeDecisionStatusPage.new
end

def dispute_type_page
  @dispute_type_page ||= DisputeTypePage.new
end

def penalty_amount_page
  @penalty_amount_page ||= PenaltyAmountPage.new
end

def in_time_page
  @in_time_page ||= InTimePage.new
end

def lateness_reason_page
  @lateness_reason_page ||= LatenessReasonPage.new
end

def grounds_for_appeal_page
  @grounds_for_appeal_page ||= GroundsForAppealPage.new
end

def eu_exit_page
  @eu_exit_page ||= EuExitPage.new
end

def outcome_page
  @outcome_page ||= OutcomePage.new
end

def need_support_page
  @need_support_page ||= NeedSupportPage.new
end

def letter_upload_type_page
  @letter_upload_type_page ||= LetterUploadTypePage.new
end

def taxpayer_details_page
  @taxpayer_details_page ||= TaxpayerDetailsPage.new
end

def has_representative_page
  @has_representative_page ||= HasRepresentativePage.new
end

def representative_professional_page
  @representative_professional_page ||= RepresentativeProfessionalPage.new
end

def taxpayer_type_page
  @taxpayer_type_page ||= TaxpayerTypePage.new
end

def user_type_page
  @user_type_page ||= UserTypePage.new
end

def letter_upload_page
  @letter_upload_page ||= LetterUploadPage.new
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

def save_return_page
  @save_return_page ||= SaveReturnPage.new
end

def save_confirmation_page
  @save_confirmation_page ||= SaveConfirmationPage.new
end

def additional_info_page
  @additional_info_page ||= AdditionalInfoPage.new
end

def support_documents_page
  @support_documents_page ||= SupportDocumentsPage.new
end

def check_answers_page
  @check_answers_page ||= CheckAnswersPage.new
end

def confirmation_page
  @confirmation_page ||= ConfirmationPage.new
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

def submit
  base_page.content.submit_button.click
end
