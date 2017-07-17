class AdminController < ApplicationController
  before_action :authenticate

  protected

  def authenticate
    authenticate_or_request_with_http_basic do |user, password|
      credentials[user] == Digest::SHA256.hexdigest(password)
    end
  end

  # We are reusing the same credentials we originally created for the upload problems report.
  # If in the future a different set of credentials were to be preferred, just implement
  # this method in each of the subclasses.
  def credentials
    { ENV.fetch('UPLOAD_PROBLEMS_REPORT_AUTH_USER') => ENV.fetch('UPLOAD_PROBLEMS_REPORT_AUTH_DIGEST') }
  end
end
