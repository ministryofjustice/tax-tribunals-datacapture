include RSpec::Mocks::ExampleMethods
def closure
  [
    proc { home_page.load_page },
    proc { home_page.close_enquiry },
    proc { closure_page.continue },
    proc { closure_case_type_page.submit_personal_return },
    proc { save_return_page.skip_save_and_return },
    proc { select_language_page.select_english_only },
    proc { submit_yes },
    proc { taxpayer_type_page.submit_individual },
    proc { taxpayer_details_page.submit_taxpayer_details },
    proc { submit_no },
    proc { submit_no },
    proc { enquiry_details_page.valid_submission },
    proc { continue_or_save_continue },
    proc { continue_or_save_continue },
    proc { submit },
  ]
end

def appeal
  [
    proc {  home_page.load_page },
    proc {  home_page.appeal },
    proc {  appeal_page.continue },
    proc {  appeal_case_type_page.submit_income_tax },
    proc {  save_return_page.skip_save_and_return },
    proc {  select_language_page.select_english_only },
    proc {  submit_yes },
    proc {  challenge_decision_status_page.submit_review_conclusion_letter },
    proc {  dispute_type_page.submit_penalty_or_surcharge },
    proc {  penalty_amount_page.submit_100_or_less },
    proc {  in_time_page.submit_yes },
    proc {  submit_yes },
    proc {  taxpayer_type_page.submit_individual },
    proc {  taxpayer_details_page.submit_taxpayer_details },
    proc {  submit_no },
    proc {  submit_no },
    proc {  grounds_for_appeal_page.valid_submission },
    proc {  submit_yes },
    proc {  outcome_page.valid_submission },
    proc {  submit_no },
    proc do
      letter_upload_type_page.submit_one_document_option
      identifier  = 'steps-details-letter-upload-form-supporting-letter-document-field'
      filename    = 'features/support/sample_file/to_upload.jpg'
      letter_upload_page.attach_file(identifier, filename)
    end,
    proc {  continue_or_save_continue },
    proc {  submit  }
  ]
end

def switch_locale
  find('.selector-locale').click_link
end

def screenshot_closure_application(journey)
  RSpec::Mocks.with_temporary_scope do
    allow(Uploader).to receive(:list_files).and_return([])
    allow(Uploader).to receive(:add_file).and_return(double(name: '123/foo/bar.png'))
    (journey == 'appeal' ? appeal : closure)
      .each do |step|
      step.call
      switch_locale
      screenshot_and_save_page
      switch_locale
    end
  end
end

# rubocop:disable MethodLength
def complete_valid_closure_application
  RSpec::Mocks.with_temporary_scope do
    allow(Uploader).to receive(:list_files).and_return([])
    allow(Uploader).to receive(:add_file).and_return(double(name: '123/foo/bar.png'))
    home_page.load_page
    expect(home_page.content).to have_header
    home_page.close_enquiry
    expect(closure_page.content).to have_header
    closure_page.continue
    expect(closure_case_type_page.content).to have_header
    closure_case_type_page.submit_personal_return
    expect(save_return_page.content).to have_header
    save_return_page.skip_save_and_return
    select_language_page.select_english_only
    expect(user_type_page.content).to have_closure_header
    if ENV['TEST_LOCALE'] == 'cy'
      submit_yes_2
    else
      submit_yes
    end
    expect(taxpayer_type_page.content).to have_closure_header
    taxpayer_type_page.submit_individual
    expect(taxpayer_details_page.content).to have_header
    taxpayer_details_page.submit_taxpayer_details
    expect(send_taxpayer_copy_page.content).to have_header
    submit_no
    expect(has_representative_page.content).to have_header
    submit_no
    expect(enquiry_details_page.content).to have_header
    enquiry_details_page.valid_submission
    expect(additional_info_page.content).to have_header
    continue_or_save_continue
    expect(eu_exit_page('closure').content).to have_header
    submit_no
    expect(need_support_page.content).to have_header
    submit_no
    expect(support_documents_page.content).to have_header
    continue_or_save_continue
    expect(check_answers_page.content).to have_header
    submit
  end
end

def complete_valid_appeal_application
  RSpec::Mocks.with_temporary_scope do
    allow(Uploader).to receive(:list_files).and_return([])
    allow(Uploader).to receive(:add_file).and_return(double(name: '123/foo/bar.png'))
    home_page.load_page
    expect(home_page.content).to have_header
    home_page.appeal
    expect(appeal_page.content).to have_header
    appeal_page.continue
    expect(appeal_case_type_page.content).to have_header
    appeal_case_type_page.submit_income_tax
    expect(save_return_page.content).to have_header
    save_return_page.skip_save_and_return
    select_language_page.select_english_only
    expect(challenge_decision_page.content).to have_appeal_header
    submit_yes
    expect(challenge_decision_status_page.content).to have_header
    challenge_decision_status_page.submit_review_conclusion_letter
    expect(dispute_type_page.content).to have_header
    dispute_type_page.submit_penalty_or_surcharge
    expect(penalty_amount_page.content).to have_header
    penalty_amount_page.submit_100_or_less
    expect(in_time_page.content).to have_header
    in_time_page.submit_yes
    expect(user_type_page.content).to have_appeal_header
    if ENV['TEST_LOCALE'] == 'cy'
      submit_yes_2
    else
      submit_yes
    end
    expect(taxpayer_type_page.content).to have_appeal_header
    taxpayer_type_page.submit_individual
    expect(taxpayer_details_page.content).to have_header
    taxpayer_details_page.submit_taxpayer_details
    expect(send_taxpayer_copy_page.content).to have_header
    submit_none
    expect(has_representative_page.content).to have_header
    submit_no
    expect(grounds_for_appeal_page.content).to have_header
    grounds_for_appeal_page.valid_submission
    expect(eu_exit_page('details').content).to have_header
    if ENV['TEST_LOCALE'] == 'cy'
      submit_yes_3
    else
      submit_yes
    end
    expect(outcome_page.content).to have_header
    outcome_page.valid_submission
    expect(need_support_page.content).to have_header
    submit_no
    expect(letter_upload_type_page.content).to have_header
    letter_upload_type_page.submit_one_document_option
    expect(letter_upload_page.content).to have_lead_text
    identifier  = 'steps-details-letter-upload-form-supporting-letter-document-field'
    filename    = 'features/support/sample_file/to_upload.jpg'
    letter_upload_page.attach_file(identifier, filename)
    continue_or_save_continue
    expect(check_answers_page.content).to have_header
    submit
  end
end

# rubocop:enable MethodLength

def go_to_login_page
  login_page.load_page
end

def create_user
  @user = FactoryBot.create(:user)
end

def login
  login_page.content.email_input.set @user.email
  login_page.content.password_input.set @user.password
  login_page.content.sign_in_button.click
end

def login_and_resume
  login_page.content.email_input.set @user.email
  login_page.content.password_input.set @user.password
  login_page.content.sign_in_button.click
  your_saved_cases_page.resume
  check_answers_resume_page.change
end

def stub_uploader_and_go_to_login_page
  allow(Uploader).to receive(:list_files).and_return([])
  allow(Uploader).to receive(:add_file).and_return(double(name: '123/foo/bar.png'))
  go_to_login_page
end

def stub_uploader
  allow(Uploader).to receive(:list_files).and_return([])
  allow(Uploader).to receive(:add_file).and_return(double(name: '123/foo/bar.png'))
end

def navigate_to_closure_case_type_page
  RSpec::Mocks.with_temporary_scope do
    create_user
    FactoryBot.create(:closure_case)
    stub_uploader_and_go_to_login_page
    login
    closure_case_type_page.load_page
  end
end

def navigate_to_appeal_case_type_page
  RSpec::Mocks.with_temporary_scope do
    create_user
    FactoryBot.create(:appeal_case)
    stub_uploader_and_go_to_login_page
    login
    appeal_case_type_page.load_page
  end

end

def navigate_to_disputed_tax_paid_page
  RSpec::Mocks.with_temporary_scope do
    create_user
    FactoryBot.create(:appeal_case, :vat_case, :yes_review, :amount_and_penalty, :valid_amount_and_penalty_amounts)
    stub_uploader_and_go_to_login_page
    login_and_resume
    disputed_tax_paid_page.load_page
  end
end

def navigate_to_closure_taxpayer_details_page(user_type)
  RSpec::Mocks.with_temporary_scope do
    create_user
    FactoryBot.create(:closure_case, :personal_return_case, user_type, :individual_taxpayer_type)
    stub_uploader_and_go_to_login_page
    login_and_resume
    taxpayer_details_page.load_page
  end
end

def navigate_to_closure_taxpayer_type_page
  RSpec::Mocks.with_temporary_scope do
    create_user
    FactoryBot.create(:closure_case, :personal_return_case, :taxpayer_user_type)
    stub_uploader_and_go_to_login_page
    login_and_resume
    taxpayer_type_page.load_page
  end
end

def navigate_to_closure_user_type_page
  RSpec::Mocks.with_temporary_scope do
    create_user
    FactoryBot.create(:closure_case, :personal_return_case)
    stub_uploader_and_go_to_login_page
    login_and_resume
    user_type_page.load_page
  end
end

def navigate_to_challenge_decision_page
  RSpec::Mocks.with_temporary_scope do
    create_user
    FactoryBot.create(:appeal_case, :income_tax_case)
    stub_uploader_and_go_to_login_page
    login_and_resume
    challenge_decision_page.load_page
  end
end

def navigate_to_what_support_page
  RSpec::Mocks.with_temporary_scope do
    create_user
    FactoryBot.create(:appeal_case, :income_tax_case, :yes_review, :received_letter, :penalty, :penalty_100_or_less,
                      :yes_in_time, :taxpayer_user_type, :individual_taxpayer_type, :valid_taxpayer_details,
                      :has_representative_no, :no_email, :valid_gfa, :valid_outcome, :yes_need_support)
    stub_uploader_and_go_to_login_page
    login_and_resume
    what_support_page.load_page
  end
end

def navigate_to_dispute_type_page(case_type)
  RSpec::Mocks.with_temporary_scope do
    create_user
    FactoryBot.create(:appeal_case, case_type, :yes_review, :received_letter)
    stub_uploader_and_go_to_login_page
    login_and_resume
    dispute_type_page.load_page
  end
end

def navigate_to_the_in_time_page
  RSpec::Mocks.with_temporary_scope do
    create_user
    FactoryBot.create(:appeal_case, :income_tax_case, :yes_review, :received_letter, :penalty, :penalty_100_or_less)
    stub_uploader_and_go_to_login_page
    login_and_resume
    in_time_page.load_page
  end
end

def navigate_to_representative_page
  RSpec::Mocks.with_temporary_scope do
    create_user
    FactoryBot.create(:appeal_case, :income_tax_case, :yes_review, :received_letter, :penalty, :penalty_100_or_less,
                      :yes_in_time, :taxpayer_user_type, :individual_taxpayer_type, :valid_taxpayer_details)
    stub_uploader_and_go_to_login_page
    login_and_resume
    has_representative_page.load_page
  end
end

def navigate_to_grounds_for_appeal_page
RSpec::Mocks.with_temporary_scope do
    create_user
    FactoryBot.create(:appeal_case, :income_tax_case, :yes_review, :received_letter, :penalty, :penalty_100_or_less,
                      :yes_in_time, :taxpayer_user_type, :individual_taxpayer_type, :valid_taxpayer_details, :no_email, :has_representative_no)
    stub_uploader_and_go_to_login_page
    login_and_resume
    grounds_for_appeal_page.load_page
  end
end

def navigate_to_enquiry_details_page
  RSpec::Mocks.with_temporary_scope do
    create_user
    FactoryBot.create(:closure_case, :personal_return_case, :taxpayer_user_type, :individual_taxpayer_type,
                      :valid_taxpayer_details, :no_email, :has_representative_no)
    stub_uploader_and_go_to_login_page
    login_and_resume
    enquiry_details_page.load_page
  end
end

def navigate_to_send_taxpayer_copy_page
  RSpec::Mocks.with_temporary_scope do
    create_user
    FactoryBot.create(:closure_case, :personal_return_case, :taxpayer_user_type, :individual_taxpayer_type,
                      :valid_taxpayer_details)
    stub_uploader_and_go_to_login_page
    login_and_resume
    send_taxpayer_copy_page.load_page
  end
end

def navigate_to_the_letter_upload_type_page
  RSpec::Mocks.with_temporary_scope do
    create_user
    FactoryBot.create(:appeal_case, :income_tax_case, :yes_review, :received_letter, :penalty, :penalty_100_or_less,
                      :yes_in_time, :taxpayer_user_type, :individual_taxpayer_type, :valid_taxpayer_details,
                      :has_representative_no, :no_email, :valid_gfa, :valid_outcome, :no_support)
    stub_uploader_and_go_to_login_page
    login_and_resume
    letter_upload_type_page.load_page
  end
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

def go_to_contact_hmrc_page                 
  contact_hmrc_page.load_page
end