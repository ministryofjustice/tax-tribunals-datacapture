RSpec::Matchers.define :validate_presence_of do |attribute, error = :blank|
  include ValidationHelpers

  match do |object|
    object.send("#{attribute}=", '')
    check_errors(object, attribute, error)
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
end

RSpec::Matchers.define :validate_email do |attribute, error = :invalid|
  include ValidationHelpers

  match do |object|
    object.send("#{attribute}=", 'x@x')
    check_errors(object, attribute, error)
  end

  description do
    "validate_email #{attribute}"
  end

  failure_message do |object|
    "expected `#{attribute}` to have error `#{error}` but got `#{errors_for(attribute, object)}`"
  end

  failure_message_when_negated do |object|
    "expected `#{attribute}` not to have error `#{error}` but got `#{errors_for(attribute, object)}`"
  end
end
