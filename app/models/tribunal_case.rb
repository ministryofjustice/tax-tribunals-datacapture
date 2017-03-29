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
  has_value_object :representative_professional_status
  has_value_object :taxpayer_type, class_name: 'ContactableEntityType'
  has_value_object :representative_type, class_name: 'ContactableEntityType'

  # Closure task
  has_value_object :closure_case_type

  # Do not store unsanitized user input that may get sent through to
  # third-party APIs.
  before_save :sanitize

  def mapping_code
    MappingCodeDeterminer.new(self).mapping_code
  end

  def documents(document_key)
    # We do not return uploaded documents when the user states they have trouble uploading
    # because otherwise they may believe they don't have to send them in again
    return [] if having_problems_uploading_documents?

    @_documents_cache ||= Document.all_for_collection(files_collection_ref)
    @_documents_cache.fetch(document_key, [])
  end

  def documents_url
    [ENV.fetch('TAX_TRIBUNALS_DOWNLOADER_URL'), files_collection_ref].join('/')
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

  private

  def sanitize
    self.class.columns.each do |col|
      # Skip uuids, integers, datetimes, et al.
      next unless [:string, :text].include?(col.type)
      value = public_send(col.name)
      # Do not attempt to sanitize nils or value object.
      if value.instance_of?(String)
        public_send("#{col.name}=", sanitizer(value))
      end
    end
  end

  def sanitizer(value)
    CGI.escapeHTML(Sanitize.fragment(value, Sanitize::Config::RESTRICTED)).
      gsub('*', '&#42;').
      gsub('=', '&#61;').
      gsub('-', '&dash;').
      gsub('%', '&#37;').
      gsub(/drop\s+table/i, '').
      gsub(/insert\s+into/i, '')
  end
end
