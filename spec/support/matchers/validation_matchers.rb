RSpec::Matchers.define :validate_presence_of do |attribute, error = :blank|
  match do |object|
    object.send("#{attribute}=", '')
    !object.valid?
    object.errors.details[attribute].include?({error: error})
  end

  description do
    "validate_presence_of #{attribute}"
  end

  failure_message do |object|
    "expected `#{attribute}` to have error `#{error}` but got `#{errors_for(attribute, object)}`"
  end

  failure_message_when_negated do |object|
    "expected `#{attribute}` not to have error `#{error}` but got `#{errors_for(attribute, object)}`"
  end

  def errors_for(attribute, object)
    object.errors.details[attribute].map { |h| h[:error] }.compact
  end
end
