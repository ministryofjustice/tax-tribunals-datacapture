class Admin::OtherDisputeTypesReportController < AdminController
  def index
    @cases_with_other_dispute_type = TribunalCase.with_other_dispute_type.order(created_at: :desc)
  end
end
