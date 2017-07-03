class Admin::UploadProblemsReportController < ApplicationController
  before_action :authenticate

  def index
    @cases_with_upload_problems = TribunalCase.with_upload_problems.order(created_at: :desc)
  end

  private

  def authenticate
    authenticate_or_request_with_http_basic do |user, password|
      credentials[user] == Digest::SHA256.hexdigest(password)
    end
  end

  def credentials
    { ENV.fetch('UPLOAD_PROBLEMS_REPORT_AUTH_USER') => ENV.fetch('UPLOAD_PROBLEMS_REPORT_AUTH_DIGEST') }
  end
end
