class LatenessReasonForm < BaseForm
  attribute :lateness_reason, String

  validates_length_of :lateness_reason, minimum: 5

  private

  def persist!
    raise 'No TribunalCase given' unless tribunal_case
    tribunal_case.update(lateness_reason: lateness_reason)
  end
end
