module WaitUntil
  def self.wait_until(timeout = 10, message = nil, &block)
    wait = Selenium::WebDriver::Wait.new(timeout: timeout, message: message)
    wait.until(&block)
  end
end

def base_page
  @base_page ||= BasePage.new
end

def homepage_page
  @homepage_page ||= HomepagePage.new
end

def login_page
  @login_page ||= LoginPage.new
end

def appeal_homepage
  @appeal_homepage ||= AppealHomepage.new
end

def appeal_page
  @appeal_page ||= AppealPage.new
end

def save_appeal_page
  @save_appeal_page ||= SaveAppealPage.new
end

def save_confirmation_page
  @save_confirmation_page ||= SaveConfirmationPage.new
end

def taxpayer_details_page
  @taxpayer_details_page ||= TaxpayerDetailsPage.new
end

def enquiry_details_page
  @enquiry_details_page ||= EnquiryDetailsPage.new
end

def closure_page
  @closure_page ||= ClosurePage.new
end

def cases_page
  @cases_page ||= CasesPage.new
end

def dispute_type_page
  @dispute_type_page ||= DisputeTypePage.new
end

def additional_info_page
  @additional_info_page ||= AdditionalInfoPage.new
end

def support_documents_page
  @support_documents_page ||= SupportDocumentsPage.new
end

def credentials_page
  @credentials_page ||= CredentialsPage.new
end

def continue
  base_page.content.continue_button.click
end

def go_to_closure_page
  homepage_page.load_page
  homepage_page.close_enquiry
end
