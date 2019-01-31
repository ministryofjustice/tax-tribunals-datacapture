module WaitUntil
  def self.wait_until(timeout = 10, message = nil, &block)
    wait = Selenium::WebDriver::Wait.new(timeout: timeout, message: message)
    wait.until(&block)
  end
end

def base_page
  @base_page ||= BasePage.new
end

def appeal_homepage
  @appeal_homepage ||= AppealHomepage.new
end

def appeal_page
  @appeal_page ||= AppealPage.new
end
