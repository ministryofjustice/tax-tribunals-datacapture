def base_page
  @base_page ||= BasePage.new
end

def home_page
  @home_page ||= HomePage.new
end

def appeal_page
  @appeal_page ||= AppealPage.new
end

def closure_page
  @closure_page ||= ClosurePage.new
end

def guidance_page
  @guidance_page ||= GuidancePage.new
end

def closure_case_type_page
  @closure_case_type_page ||= ClosureCaseTypePage.new
end

def enquiry_details_page
  @enquiry_details_page ||= EnquiryDetailsPage.new
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

def your_saved_cases_page
  @your_saved_cases_page ||= YourSavedCasesPage.new
end

def check_answers_resume_page
  @check_answers_resume_page ||= CheckAnswersResumePage.new
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

def send_taxpayer_copy_page
  @send_taxpayer_copy_page ||= SendTaxpayerCopyPage.new
end

def send_representative_copy_page
  @send_representative_copy_page ||= SendRepresentativeCopyPage.new
end

def tax_amount_page
  @tax_amount_page ||= TaxAmountPage.new
end

def penalty_amount_page
  @penalty_amount_page ||= PenaltyAmountPage.new
end

def penalty_and_tax_amounts_page
  @penalty_and_tax_amounts_page ||= PenaltyAndTaxAmountsPage.new
end

def disputed_tax_paid_page
  @disputed_tax_paid_page ||= DisputedTaxPaidPage.new
end

def hardship_review_requested_page
  @hardship_review_requested_page ||= HardshipReviewRequestedPage.new
end

def hardship_review_status_page
  @hardship_review_status_page ||= HardshipReviewStatusPage.new
end

def hardship_reason_page
  @hardship_reason_page ||= HardshipReasonPage.new
end

def in_time_page
  @in_time_page ||= InTimePage.new
end

def contact_hmrc_page
  @contact_hmrc_page ||= ContactHmrcPage.new
end

def lateness_reason_page
  @lateness_reason_page ||= LatenessReasonPage.new
end

def grounds_for_appeal_page
  @grounds_for_appeal_page ||= GroundsForAppealPage.new
end

def eu_exit_page(pathway)
  @eu_exit_page ||= EuExitPage.new(pathway)
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

def representative_details_page
  @representative_details_page ||= RepresentativeDetailsPage.new
end

def has_representative_page
  @has_representative_page ||= HasRepresentativePage.new
end

def representative_type_page
  @representative_type_page ||= RepresentativeTypePage.new
end

def representative_professional_page
  @representative_professional_page ||= RepresentativeProfessionalPage.new
end

def representative_approval_page
  @representative_approval_page ||= RepresentativeApprovalPage.new
end

def taxpayer_type_page
  @taxpayer_type_page ||= TaxpayerTypePage.new
end

def user_type_page
  @user_type_page ||= UserTypePage.new
end

def what_support_page
  @what_support_page ||= WhatSupportPage.new
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

def select_language_page
  @select_language ||= SelectLanguagePage.new
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

def cookie_page
  @cookie_page ||= CookiePage.new
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

def continue_or_save_continue
  base_page.content.continue_or_save_continue.click
end

def submit_yes
  base_page.content.yes_option.click
  continue_or_save_continue
end

def yes_option
  base_page.content.yes_option.click
end

def submit_no
  base_page.content.no_option.click
  continue_or_save_continue
end

def submit_yes_welsh
  base_page.content.yes_option_welsh.click
  continue_or_save_continue
end

def submit_yes_2
  base_page.content.yes_option_welsh_2.click
  continue_or_save_continue
end

def submit_yes_3
  base_page.content.yes_option_welsh_3.click
  continue_or_save_continue
end

def submit_no_welsh
  base_page.content.no_option_welsh.click
  continue_or_save_continue
end

def submit_no_welsh_2
  base_page.content.no_option_welsh_2.click
  continue_or_save_continue
end

def back
  base_page.back_button.click
end

def save_and_come_back
  base_page.content.save_and_come_back_link.click
end
