class TribunalCase < ApplicationRecord
  has_value_object :intent
  has_value_object :case_status

  # Appeal task
  has_value_object :challenged_decision
  has_value_object :challenged_decision_status
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
  has_value_object :user_type
  has_value_object :has_representative
  has_value_object :representative_is_legal_professional
  has_value_object :taxpayer_type, class_name: 'ContactableEntityType'
  has_value_object :representative_type, class_name: 'ContactableEntityType'

  # Closure task
  has_value_object :closure_case_type

  def mapping_code
    MappingCodeDeterminer.new(self).mapping_code
  end

  def documents(document_key)
    Document.for_collection(files_collection_ref, document_key: document_key)
  end

  def taxpayer_is_organisation?
    taxpayer_type.organisation?
  end

  def representative_is_organisation?
    representative_type.organisation?
  end

  def appeal_or_application
    return :application if intent.eql?(Intent::CLOSE_ENQUIRY)
    return :appeal      unless case_type

    case_type.appeal_or_application
  end

  def started_by_taxpayer?
    user_type.eql?(UserType::TAXPAYER)
  end

  def started_by_representative?
    user_type.eql?(UserType::REPRESENTATIVE)
  end
end
