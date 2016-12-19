class TribunalCase < ApplicationRecord
  # Cost task
  has_value_object :challenged_decision
  has_value_object :case_type, constructor: :find_constant
  has_value_object :dispute_type
  has_value_object :penalty_amount
  has_value_object :lodgement_fee

  # Lateness task
  has_value_object :in_time

  # Details task
  has_value_object :taxpayer_type

  def cost_task_completed?
    lodgement_fee?
  end

  def lateness_task_completed?
    return false unless cost_task_completed? && in_time?
    in_time.eql?(InTime::YES) || lateness_reason?
  end

  def documents(filter: default_documents_filter)
    Document.for_collection(files_collection_ref, filter: filter)
  end

  def default_documents_filter
    [grounds_for_appeal_file_name]
  end
end
