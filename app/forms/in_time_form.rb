class InTimeForm < BaseForm
  attribute :in_time, String

  def self.choices
    InTime.values.map(&:to_s)
  end
  validates_inclusion_of :in_time, in: choices

  private

  def in_time_value
    InTime.new(in_time)
  end

  def changed?
    tribunal_case.in_time != in_time_value
  end

  def persist!
    raise 'No TribunalCase given' unless tribunal_case
    return true unless changed?

    tribunal_case.update(
      in_time:         in_time_value,
      # The following are dependent attributes that need to be reset
      lateness_reason: nil
    )
  end
end
