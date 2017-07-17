class Admin::UploadProblemsReportController < AdminController
  def index
    @cases_with_upload_problems = TribunalCase.with_upload_problems.order(created_at: :desc)
  end
end
