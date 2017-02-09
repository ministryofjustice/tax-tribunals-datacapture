class ClosureEnquiryAnswersPresenter < BaseAnswersPresenter
  def rows
    [
      hmrc_reference_question,
      years_under_enquiry_question,
      hmrc_officer_question,
      additional_info_question
    ].compact
  end

  private

  def hmrc_reference_question
    row(
      tribunal_case.closure_hmrc_reference,
      as: :hmrc_reference,
      i18n_value: false,
      change_path: edit_steps_closure_enquiry_details_path
    )
  end

  def years_under_enquiry_question
    row(
      tribunal_case.closure_years_under_enquiry,
      as: :years_under_enquiry,
      i18n_value: false,
      change_path: edit_steps_closure_enquiry_details_path
    )
  end

  def hmrc_officer_question
    row(
      tribunal_case.closure_hmrc_officer,
      as: :hmrc_officer,
      i18n_value: false,
      change_path: edit_steps_closure_enquiry_details_path
    )
  end

  def additional_info_question
    row(
      tribunal_case.closure_additional_info,
      as: :additional_info,
      i18n_value: false,
      change_path: edit_steps_closure_additional_info_path
    )
  end
end
