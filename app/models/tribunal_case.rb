class TribunalCase < ApplicationRecord
  # Cost task
  has_value_object :challenged_decision
  has_value_object :case_type, constructor: :find_constant
  has_value_object :dispute_type
  has_value_object :penalty_level

  # Hardship task
  has_value_object :disputed_tax_paid
  has_value_object :hardship_review_requested
  has_value_object :hardship_review_status

  # Lateness task
  has_value_object :in_time

  # Details task
  has_value_object :taxpayer_type, class_name: 'ContactableEntityType'

  # Closure task
  has_value_object :intent
  has_value_object :closure_case_type

  def mapping_code
    MappingCodeDeterminer.new(self).mapping_code
  end

  def lodgement_fee
    GlimrFees.lodgement_fee_amount(self)
  end

  def cost_task_completed?
    MappingCodeDeterminer.new(self).valid_for_determining_mapping_code?
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

  def taxpayer_is_organisation?
    taxpayer_type.organisation?
  end
end
