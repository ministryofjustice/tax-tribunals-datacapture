include RSpec::Mocks::ExampleMethods

def go_to_closure_page
  home_page.load_page
  expect(home_page.content).to have_header
  home_page.close_enquiry
  expect(closure_page.content).to have_header
end

def go_to_closure_case_type_page
  home_page.load_page
  expect(home_page.content).to have_header
  home_page.close_enquiry
  expect(closure_page.content).to have_header
  closure_page.continue
  expect(case_type_page.content).to have_closure_header
end

def go_to_closure_save_and_return_page
  home_page.load_page
  expect(home_page.content).to have_header
  home_page.close_enquiry
  expect(closure_page.content).to have_header
  closure_page.continue
  expect(case_type_page.content).to have_closure_header
  case_type_page.submit_personal_return
  expect(save_return_page.content).to have_header
end

def go_to_closure_user_type_page
  home_page.load_page
  expect(home_page.content).to have_header
  home_page.close_enquiry
  expect(closure_page.content).to have_header
  closure_page.continue
  expect(case_type_page.content).to have_closure_header
  case_type_page.submit_personal_return
  expect(save_return_page.content).to have_header
  save_return_page.skip_save_and_return
  expect(user_type_page.content).to have_closure_header
end

def go_to_closure_taxpayer_type_page
  home_page.load_page
  expect(home_page.content).to have_header
  home_page.close_enquiry
  expect(closure_page.content).to have_header
  closure_page.continue
  expect(case_type_page.content).to have_closure_header
  case_type_page.submit_personal_return
  expect(save_return_page.content).to have_header
  save_return_page.skip_save_and_return
  expect(user_type_page.content).to have_closure_header
  user_type_page.submit_yes
  expect(taxpayer_type_page.content).to have_closure_header
end

def go_to_closure_taxpayer_details_page
  home_page.load_page
  expect(home_page.content).to have_header
  home_page.close_enquiry
  expect(closure_page.content).to have_header
  closure_page.continue
  expect(case_type_page.content).to have_closure_header
  case_type_page.submit_personal_return
  expect(save_return_page.content).to have_header
  save_return_page.skip_save_and_return
  expect(user_type_page.content).to have_closure_header
  user_type_page.submit_yes
  expect(taxpayer_type_page.content).to have_closure_header
  taxpayer_type_page.submit_individual
  expect(taxpayer_details_page.content).to have_header
end

def go_to_closure_has_representative_page
  home_page.load_page
  expect(home_page.content).to have_header
  home_page.close_enquiry
  expect(closure_page.content).to have_header
  closure_page.continue
  case_type_page.submit_personal_return
  expect(save_return_page.content).to have_header
  save_return_page.skip_save_and_return
  expect(user_type_page.content).to have_closure_header
  user_type_page.submit_yes
  expect(taxpayer_type_page.content).to have_closure_header
  taxpayer_type_page.submit_individual
  expect(taxpayer_details_page.content).to have_header
  taxpayer_details_page.submit_taxpayer_details
  expect(has_representative_page.content).to have_header
end

def go_to_enquiry_details_page
  home_page.load_page
  expect(home_page.content).to have_header
  home_page.close_enquiry
  expect(closure_page.content).to have_header
  closure_page.continue
  expect(case_type_page.content).to have_closure_header
  case_type_page.submit_personal_return
  expect(save_return_page.content).to have_header
  save_return_page.skip_save_and_return
  expect(user_type_page.content).to have_closure_header
  user_type_page.submit_yes
  expect(taxpayer_type_page.content).to have_closure_header
  taxpayer_type_page.submit_individual
  expect(taxpayer_details_page.content).to have_header
  taxpayer_details_page.submit_taxpayer_details
  expect(has_representative_page.content).to have_header
  has_representative_page.submit_no
  expect(enquiry_details_page.content).to have_header
end

def go_to_additional_info_page
  RSpec::Mocks.with_temporary_scope do
    allow(Uploader).to receive(:list_files).and_return([])
    allow(Uploader).to receive(:add_file).and_return([])
    home_page.load_page
    expect(home_page.content).to have_header
    home_page.close_enquiry
    expect(closure_page.content).to have_header
    closure_page.continue
    expect(case_type_page.content).to have_closure_header
    case_type_page.submit_personal_return
    expect(save_return_page.content).to have_header
    save_return_page.skip_save_and_return
    expect(user_type_page.content).to have_closure_header
    user_type_page.submit_yes
    expect(taxpayer_type_page.content).to have_closure_header
    taxpayer_type_page.submit_individual
    expect(taxpayer_details_page.content).to have_header
    taxpayer_details_page.submit_taxpayer_details
    expect(has_representative_page.content).to have_header
    has_representative_page.submit_no
    expect(enquiry_details_page.content).to have_header
    enquiry_details_page.valid_submission
    expect(additional_info_page.content).to have_header
  end
end

def go_to_support_documents_page
  RSpec::Mocks.with_temporary_scope do
    allow(Uploader).to receive(:list_files).and_return([])
    allow(Uploader).to receive(:add_file).and_return([])
    home_page.load_page
    expect(home_page.content).to have_header
    home_page.close_enquiry
    expect(closure_page.content).to have_header
    closure_page.continue
    expect(case_type_page.content).to have_closure_header
    case_type_page.submit_personal_return
    expect(save_return_page.content).to have_header
    save_return_page.skip_save_and_return
    expect(user_type_page.content).to have_closure_header
    user_type_page.submit_yes
    expect(taxpayer_type_page.content).to have_closure_header
    taxpayer_type_page.submit_individual
    expect(taxpayer_details_page.content).to have_header
    taxpayer_details_page.submit_taxpayer_details
    expect(has_representative_page.content).to have_header
    has_representative_page.submit_no
    expect(enquiry_details_page.content).to have_header
    enquiry_details_page.valid_submission
    expect(additional_info_page.content).to have_header
    continue
    expect(support_documents_page.content).to have_header
  end
end

def go_to_closure_check_answers_page
  RSpec::Mocks.with_temporary_scope do
    allow(Uploader).to receive(:list_files).and_return([])
    allow(Uploader).to receive(:add_file).and_return([])
    home_page.load_page
    expect(home_page.content).to have_header
    home_page.close_enquiry
    expect(closure_page.content).to have_header
    closure_page.continue
    expect(case_type_page.content).to have_closure_header
    case_type_page.submit_personal_return
    expect(save_return_page.content).to have_header
    save_return_page.skip_save_and_return
    expect(user_type_page.content).to have_closure_header
    user_type_page.submit_yes
    expect(taxpayer_type_page.content).to have_closure_header
    taxpayer_type_page.submit_individual
    expect(taxpayer_details_page.content).to have_header
    taxpayer_details_page.submit_taxpayer_details
    expect(has_representative_page.content).to have_header
    has_representative_page.submit_no
    expect(enquiry_details_page.content).to have_header
    enquiry_details_page.valid_submission
    expect(additional_info_page.content).to have_header
    continue
    expect(support_documents_page.content).to have_header
    continue
    expect(check_answers_page.content).to have_header
  end
end

def complete_valid_closure_application
  RSpec::Mocks.with_temporary_scope do
    allow(Uploader).to receive(:list_files).and_return([])
    allow(Uploader).to receive(:add_file).and_return([])
    home_page.load_page
    expect(home_page.content).to have_header
    home_page.close_enquiry
    expect(closure_page.content).to have_header
    closure_page.continue
    expect(case_type_page.content).to have_closure_header
    case_type_page.submit_personal_return
    expect(save_return_page.content).to have_header
    save_return_page.skip_save_and_return
    expect(user_type_page.content).to have_closure_header
    user_type_page.submit_yes
    expect(taxpayer_type_page.content).to have_closure_header
    taxpayer_type_page.submit_individual
    expect(taxpayer_details_page.content).to have_header
    taxpayer_details_page.submit_taxpayer_details
    expect(has_representative_page.content).to have_header
    has_representative_page.submit_no
    expect(enquiry_details_page.content).to have_header
    enquiry_details_page.valid_submission
    expect(additional_info_page.content).to have_header
    continue
    expect(support_documents_page.content).to have_header
    continue
    expect(check_answers_page.content).to have_header
    submit
  end
end

def go_to_appeal_page
  home_page.load_page
  expect(home_page.content).to have_header
  home_page.appeal
  expect(appeal_page.content).to have_header
end

def go_to_appeal_case_type_page
  home_page.load_page
  expect(home_page.content).to have_header
  home_page.appeal
  expect(appeal_page.content).to have_header
  appeal_page.continue
  expect(case_type_page.content).to have_appeal_header
end

def go_to_appeal_save_and_return_page
  home_page.load_page
  expect(home_page.content).to have_header
  home_page.appeal
  expect(appeal_page.content).to have_header
  appeal_page.continue
  expect(case_type_page.content).to have_appeal_header
  case_type_page.submit_income_tax
  expect(save_return_page.content).to have_header
end

def go_to_challenge_decision_page
  home_page.load_page
  expect(home_page.content).to have_header
  home_page.appeal
  expect(appeal_page.content).to have_header
  appeal_page.continue
  expect(case_type_page.content).to have_appeal_header
  case_type_page.submit_income_tax
  expect(save_return_page.content).to have_header
  save_return_page.skip_save_and_return
  expect(challenge_decision_page.content).to have_header
end

def go_to_challenge_decision_status_page
  home_page.load_page
  expect(home_page.content).to have_header
  home_page.appeal
  expect(appeal_page.content).to have_header
  appeal_page.continue
  expect(case_type_page.content).to have_appeal_header
  case_type_page.submit_income_tax
  expect(save_return_page.content).to have_header
  save_return_page.skip_save_and_return
  expect(challenge_decision_page.content).to have_header
  challenge_decision_page.submit_yes
  expect(challenge_decision_status_page.content).to have_header
end

def go_to_dispute_type_page
  home_page.load_page
  expect(home_page.content).to have_header
  home_page.appeal
  expect(appeal_page.content).to have_header
  appeal_page.continue
  expect(case_type_page.content).to have_appeal_header
  case_type_page.submit_income_tax
  expect(save_return_page.content).to have_header
  save_return_page.skip_save_and_return
  expect(challenge_decision_page.content).to have_header
  challenge_decision_page.submit_yes
  expect(challenge_decision_status_page.content).to have_header
  challenge_decision_status_page.submit_review_conclusion_letter
  expect(dispute_type_page.content).to have_header
end

def go_to_penalty_amount_page
  home_page.load_page
  expect(home_page.content).to have_header
  home_page.appeal
  expect(appeal_page.content).to have_header
  appeal_page.continue
  expect(case_type_page.content).to have_appeal_header
  case_type_page.submit_income_tax
  expect(save_return_page.content).to have_header
  save_return_page.skip_save_and_return
  expect(challenge_decision_page.content).to have_header
  challenge_decision_page.submit_yes
  expect(challenge_decision_status_page.content).to have_header
  challenge_decision_status_page.submit_review_conclusion_letter
  expect(dispute_type_page.content).to have_header
  dispute_type_page.submit_penalty_or_surcharge
  expect(penalty_amount_page.content).to have_header
end

def go_to_in_time_page
  home_page.load_page
  expect(home_page.content).to have_header
  home_page.appeal
  expect(appeal_page.content).to have_header
  appeal_page.continue
  expect(case_type_page.content).to have_appeal_header
  case_type_page.submit_income_tax
  expect(save_return_page.content).to have_header
  save_return_page.skip_save_and_return
  expect(challenge_decision_page.content).to have_header
  challenge_decision_page.submit_yes
  expect(challenge_decision_status_page.content).to have_header
  challenge_decision_status_page.submit_review_conclusion_letter
  expect(dispute_type_page.content).to have_header
  dispute_type_page.submit_penalty_or_surcharge
  expect(penalty_amount_page.content).to have_header
  penalty_amount_page.submit_100_or_less
  expect(in_time_page.content).to have_header
end

def go_to_appeal_user_type_page
  home_page.load_page
  expect(home_page.content).to have_header
  home_page.appeal
  expect(appeal_page.content).to have_header
  appeal_page.continue
  expect(case_type_page.content).to have_appeal_header
  case_type_page.submit_income_tax
  expect(save_return_page.content).to have_header
  save_return_page.skip_save_and_return
  expect(challenge_decision_page.content).to have_header
  challenge_decision_page.submit_yes
  expect(challenge_decision_status_page.content).to have_header
  challenge_decision_status_page.submit_review_conclusion_letter
  expect(dispute_type_page.content).to have_header
  dispute_type_page.submit_penalty_or_surcharge
  expect(penalty_amount_page.content).to have_header
  penalty_amount_page.submit_100_or_less
  expect(in_time_page.content).to have_header
  in_time_page.submit_yes
  expect(user_type_page.content).to have_appeal_header
end

def go_to_appeal_taxpayer_type_page
  home_page.load_page
  expect(home_page.content).to have_header
  home_page.appeal
  expect(appeal_page.content).to have_header
  appeal_page.continue
  expect(case_type_page.content).to have_appeal_header
  case_type_page.submit_income_tax
  expect(save_return_page.content).to have_header
  save_return_page.skip_save_and_return
  expect(challenge_decision_page.content).to have_header
  challenge_decision_page.submit_yes
  expect(challenge_decision_status_page.content).to have_header
  challenge_decision_status_page.submit_review_conclusion_letter
  expect(dispute_type_page.content).to have_header
  dispute_type_page.submit_penalty_or_surcharge
  expect(penalty_amount_page.content).to have_header
  penalty_amount_page.submit_100_or_less
  expect(in_time_page.content).to have_header
  in_time_page.submit_yes
  expect(user_type_page.content).to have_appeal_header
  user_type_page.submit_yes
  expect(taxpayer_type_page.content).to have_appeal_header
end

def go_to_appeal_taxpayer_details_page
  home_page.load_page
  expect(home_page.content).to have_header
  home_page.appeal
  expect(appeal_page.content).to have_header
  appeal_page.continue
  expect(case_type_page.content).to have_appeal_header
  case_type_page.submit_income_tax
  expect(save_return_page.content).to have_header
  save_return_page.skip_save_and_return
  expect(challenge_decision_page.content).to have_header
  challenge_decision_page.submit_yes
  expect(challenge_decision_status_page.content).to have_header
  challenge_decision_status_page.submit_review_conclusion_letter
  expect(dispute_type_page.content).to have_header
  dispute_type_page.submit_penalty_or_surcharge
  expect(penalty_amount_page.content).to have_header
  penalty_amount_page.submit_100_or_less
  expect(in_time_page.content).to have_header
  in_time_page.submit_yes
  expect(user_type_page.content).to have_appeal_header
  user_type_page.submit_yes
  expect(taxpayer_type_page.content).to have_appeal_header
  taxpayer_type_page.submit_individual
  expect(taxpayer_details_page.content).to have_header
end

def go_to_appeal_has_representative_page
  home_page.load_page
  expect(home_page.content).to have_header
  home_page.appeal
  expect(appeal_page.content).to have_header
  appeal_page.continue
  expect(case_type_page.content).to have_appeal_header
  case_type_page.submit_income_tax
  expect(save_return_page.content).to have_header
  save_return_page.skip_save_and_return
  expect(challenge_decision_page.content).to have_header
  challenge_decision_page.submit_yes
  expect(challenge_decision_status_page.content).to have_header
  challenge_decision_status_page.submit_review_conclusion_letter
  expect(dispute_type_page.content).to have_header
  dispute_type_page.submit_penalty_or_surcharge
  expect(penalty_amount_page.content).to have_header
  penalty_amount_page.submit_100_or_less
  expect(in_time_page.content).to have_header
  in_time_page.submit_yes
  expect(user_type_page.content).to have_appeal_header
  user_type_page.submit_yes
  expect(taxpayer_type_page.content).to have_appeal_header
  taxpayer_type_page.submit_individual
  expect(taxpayer_details_page.content).to have_header
  taxpayer_details_page.submit_taxpayer_details
  expect(has_representative_page.content).to have_header
end

def go_to_grounds_for_appeal_page
  home_page.load_page
  expect(home_page.content).to have_header
  home_page.appeal
  expect(appeal_page.content).to have_header
  appeal_page.continue
  expect(case_type_page.content).to have_appeal_header
  case_type_page.submit_income_tax
  expect(save_return_page.content).to have_header
  save_return_page.skip_save_and_return
  expect(challenge_decision_page.content).to have_header
  challenge_decision_page.submit_yes
  expect(challenge_decision_status_page.content).to have_header
  challenge_decision_status_page.submit_review_conclusion_letter
  expect(dispute_type_page.content).to have_header
  dispute_type_page.submit_penalty_or_surcharge
  expect(penalty_amount_page.content).to have_header
  penalty_amount_page.submit_100_or_less
  expect(in_time_page.content).to have_header
  in_time_page.submit_yes
  expect(user_type_page.content).to have_appeal_header
  user_type_page.submit_yes
  expect(taxpayer_type_page.content).to have_appeal_header
  taxpayer_type_page.submit_individual
  expect(taxpayer_details_page.content).to have_header
  taxpayer_details_page.submit_taxpayer_details
  expect(has_representative_page.content).to have_header
  has_representative_page.submit_no
  expect(grounds_for_appeal_page.content).to have_header
end

def go_to_outcome_page
  home_page.load_page
  expect(home_page.content).to have_header
  home_page.appeal
  expect(appeal_page.content).to have_header
  appeal_page.continue
  expect(case_type_page.content).to have_appeal_header
  case_type_page.submit_income_tax
  expect(save_return_page.content).to have_header
  save_return_page.skip_save_and_return
  expect(challenge_decision_page.content).to have_header
  challenge_decision_page.submit_yes
  expect(challenge_decision_status_page.content).to have_header
  challenge_decision_status_page.submit_review_conclusion_letter
  expect(dispute_type_page.content).to have_header
  dispute_type_page.submit_penalty_or_surcharge
  expect(penalty_amount_page.content).to have_header
  penalty_amount_page.submit_100_or_less
  expect(in_time_page.content).to have_header
  in_time_page.submit_yes
  expect(user_type_page.content).to have_appeal_header
  user_type_page.submit_yes
  expect(taxpayer_type_page.content).to have_appeal_header
  taxpayer_type_page.submit_individual
  expect(taxpayer_details_page.content).to have_header
  taxpayer_details_page.submit_taxpayer_details
  expect(has_representative_page.content).to have_header
  has_representative_page.submit_no
  expect(grounds_for_appeal_page.content).to have_header
  grounds_for_appeal_page.valid_submission
  expect(outcome_page.content).to have_header
end

def go_to_need_support_page
  home_page.load_page
  expect(home_page.content).to have_header
  home_page.appeal
  expect(appeal_page.content).to have_header
  appeal_page.continue
  expect(case_type_page.content).to have_appeal_header
  case_type_page.submit_income_tax
  expect(save_return_page.content).to have_header
  save_return_page.skip_save_and_return
  expect(challenge_decision_page.content).to have_header
  challenge_decision_page.submit_yes
  expect(challenge_decision_status_page.content).to have_header
  challenge_decision_status_page.submit_review_conclusion_letter
  expect(dispute_type_page.content).to have_header
  dispute_type_page.submit_penalty_or_surcharge
  expect(penalty_amount_page.content).to have_header
  penalty_amount_page.submit_100_or_less
  expect(in_time_page.content).to have_header
  in_time_page.submit_yes
  expect(user_type_page.content).to have_appeal_header
  user_type_page.submit_yes
  expect(taxpayer_type_page.content).to have_appeal_header
  taxpayer_type_page.submit_individual
  expect(taxpayer_details_page.content).to have_header
  taxpayer_details_page.submit_taxpayer_details
  expect(has_representative_page.content).to have_header
  has_representative_page.submit_no
  expect(grounds_for_appeal_page.content).to have_header
  grounds_for_appeal_page.valid_submission
  expect(outcome_page.content).to have_header
  outcome_page.valid_submission
  expect(need_support_page.content).to have_header
end

def go_to_letter_upload_type_page
  home_page.load_page
  expect(home_page.content).to have_header
  home_page.appeal
  expect(appeal_page.content).to have_header
  appeal_page.continue
  expect(case_type_page.content).to have_appeal_header
  case_type_page.submit_income_tax
  expect(save_return_page.content).to have_header
  save_return_page.skip_save_and_return
  expect(challenge_decision_page.content).to have_header
  challenge_decision_page.submit_yes
  expect(challenge_decision_status_page.content).to have_header
  challenge_decision_status_page.submit_review_conclusion_letter
  expect(dispute_type_page.content).to have_header
  dispute_type_page.submit_penalty_or_surcharge
  expect(penalty_amount_page.content).to have_header
  penalty_amount_page.submit_100_or_less
  expect(in_time_page.content).to have_header
  in_time_page.submit_yes
  expect(user_type_page.content).to have_appeal_header
  user_type_page.submit_yes
  expect(taxpayer_type_page.content).to have_appeal_header
  taxpayer_type_page.submit_individual
  expect(taxpayer_details_page.content).to have_header
  taxpayer_details_page.submit_taxpayer_details
  expect(has_representative_page.content).to have_header
  has_representative_page.submit_no
  expect(grounds_for_appeal_page.content).to have_header
  grounds_for_appeal_page.valid_submission
  expect(outcome_page.content).to have_header
  outcome_page.valid_submission
  expect(need_support_page.content).to have_header
  need_support_page.submit_no
  expect(letter_upload_type_page.content).to have_header
end

def go_to_letter_upload_page
  home_page.load_page
  expect(home_page.content).to have_header
  home_page.appeal
  expect(appeal_page.content).to have_header
  appeal_page.continue
  expect(case_type_page.content).to have_appeal_header
  case_type_page.submit_income_tax
  expect(save_return_page.content).to have_header
  save_return_page.skip_save_and_return
  expect(challenge_decision_page.content).to have_header
  challenge_decision_page.submit_yes
  expect(challenge_decision_status_page.content).to have_header
  challenge_decision_status_page.submit_review_conclusion_letter
  expect(dispute_type_page.content).to have_header
  dispute_type_page.submit_penalty_or_surcharge
  expect(penalty_amount_page.content).to have_header
  penalty_amount_page.submit_100_or_less
  expect(in_time_page.content).to have_header
  in_time_page.submit_yes
  expect(user_type_page.content).to have_appeal_header
  user_type_page.submit_yes
  expect(taxpayer_type_page.content).to have_appeal_header
  taxpayer_type_page.submit_individual
  expect(taxpayer_details_page.content).to have_header
  taxpayer_details_page.submit_taxpayer_details
  expect(has_representative_page.content).to have_header
  has_representative_page.submit_no
  expect(grounds_for_appeal_page.content).to have_header
  grounds_for_appeal_page.valid_submission
  expect(outcome_page.content).to have_header
  outcome_page.valid_submission
  expect(need_support_page.content).to have_header
  need_support_page.submit_no
  expect(letter_upload_type_page.content).to have_header
  letter_upload_type_page.submit_one_document_option
  expect(letter_upload_page.content).to have_lead_text
end

def go_to_appeal_check_answers_page
  home_page.load_page
  expect(home_page.content).to have_header
  home_page.appeal
  expect(appeal_page.content).to have_header
  appeal_page.continue
  expect(case_type_page.content).to have_appeal_header
  case_type_page.submit_income_tax
  expect(save_return_page.content).to have_header
  save_return_page.skip_save_and_return
  expect(challenge_decision_page.content).to have_header
  challenge_decision_page.submit_yes
  expect(challenge_decision_status_page.content).to have_header
  challenge_decision_status_page.submit_review_conclusion_letter
  expect(dispute_type_page.content).to have_header
  dispute_type_page.submit_penalty_or_surcharge
  expect(penalty_amount_page.content).to have_header
  penalty_amount_page.submit_100_or_less
  expect(in_time_page.content).to have_header
  in_time_page.submit_yes
  expect(user_type_page.content).to have_appeal_header
  user_type_page.submit_yes
  expect(taxpayer_type_page.content).to have_appeal_header
  taxpayer_type_page.submit_individual
  expect(taxpayer_details_page.content).to have_header
  taxpayer_details_page.submit_taxpayer_details
  expect(has_representative_page.content).to have_header
  has_representative_page.submit_no
  expect(grounds_for_appeal_page.content).to have_header
  grounds_for_appeal_page.valid_submission
  expect(outcome_page.content).to have_header
  outcome_page.valid_submission
  expect(need_support_page.content).to have_header
  need_support_page.submit_no
  expect(letter_upload_type_page.content).to have_header
  letter_upload_type_page.submit_one_document_option
  expect(letter_upload_page.content).to have_lead_text
  identifier  = 'steps-details-letter-upload-form-supporting-letter-document-field'
  filename    = 'features/support/sample_file/sample.docx'
  letter_upload_page.attach_file(identifier, filename)
  continue
  expect(check_answers_page.content).to have_header
end

def complete_valid_appeal_application
  RSpec::Mocks.with_temporary_scope do
    allow(Uploader).to receive(:list_files).and_return([])
    allow(Uploader).to receive(:add_file).and_return([])
    home_page.load_page
    expect(home_page.content).to have_header
    home_page.appeal
    expect(appeal_page.content).to have_header
    appeal_page.continue
    expect(case_type_page.content).to have_appeal_header
    case_type_page.submit_income_tax
    expect(save_return_page.content).to have_header
    save_return_page.skip_save_and_return
    expect(challenge_decision_page.content).to have_header
    challenge_decision_page.submit_yes
    expect(challenge_decision_status_page.content).to have_header
    challenge_decision_status_page.submit_review_conclusion_letter
    expect(dispute_type_page.content).to have_header
    dispute_type_page.submit_penalty_or_surcharge
    expect(penalty_amount_page.content).to have_header
    penalty_amount_page.submit_100_or_less
    expect(in_time_page.content).to have_header
    in_time_page.submit_yes
    expect(user_type_page.content).to have_appeal_header
    user_type_page.submit_yes
    expect(taxpayer_type_page.content).to have_appeal_header
    taxpayer_type_page.submit_individual
    expect(taxpayer_details_page.content).to have_header
    taxpayer_details_page.submit_taxpayer_details
    expect(has_representative_page.content).to have_header
    has_representative_page.submit_no
    expect(grounds_for_appeal_page.content).to have_header
    grounds_for_appeal_page.valid_submission
    expect(outcome_page.content).to have_header
    outcome_page.valid_submission
    expect(need_support_page.content).to have_header
    need_support_page.submit_no
    expect(letter_upload_type_page.content).to have_header
    letter_upload_type_page.submit_one_document_option
    expect(letter_upload_page.content).to have_lead_text
    identifier  = 'steps-details-letter-upload-form-supporting-letter-document-field'
    filename    = 'features/support/sample_file/sample.docx'
    letter_upload_page.attach_file(identifier, filename)
    continue
    expect(check_answers_page.content).to have_header
    submit
  end
end

def go_to_login_page
  login_page.load_page
end

def go_to_contact_page
  home_page.load_page
  base_page.footer.contact_link.click
end

def go_to_cookies_page
  home_page.load_page
  base_page.footer.cookies_link.click
end

def go_to_terms_page
  home_page.load_page
  base_page.footer.terms_link.click
end

def go_to_privacy_page
  home_page.load_page
  base_page.footer.privacy_link.click
end

def go_to_accessibility_page
  home_page.load_page
  base_page.footer.accessibility_link.click
end
