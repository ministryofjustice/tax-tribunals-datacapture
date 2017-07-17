class Admin::OtherCaseTypesReportController < AdminController
  def index
    @cases_with_other_type = TribunalCase.with_other_case_type.order(created_at: :desc)
  end
end
