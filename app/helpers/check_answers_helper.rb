module CheckAnswersHelper

  # Like t() but with cascading and offset. See config/initializers/i18n_cascading.rb
  # We use a dynamic offset so that the segment 'pdf' is always removed from the scope (zero-indexed).
  #
  # Example 1. Given an original key of:
  #   .appeal_details_heading
  # in the scope of:
  #   en.steps.details.check_answers.pdf.show.appeal_details_heading
  # and key is not found, it will try the following key:
  #   en.steps.details.check_answers.show.appeal_details_heading
  #
  # Example 2. Given an original key of:
  #   .questions.case_type
  # in the scope of:
  #   en.steps.details.check_answers.pdf.show.questions.case_type
  # and key is not found, it will try the following key:
  #   en.steps.details.check_answers.show.questions.case_type
  #
  def pdf_t(key, options = {})
    cascade_params = {cascade: {offset: key.count('.') + 1}}
    translate(key, options.merge(cascade_params).merge(appeal_or_application_params))
  end

end
