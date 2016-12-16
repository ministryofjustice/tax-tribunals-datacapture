require 'rspec/expectations'

RSpec::Matchers.define :have_lodgement_fee do |fee_level|
  match do |cost_determiner|
    cost_determiner.lodgement_fee == LodgementFee.new(fee_level)
  end

  failure_message do |cost_determiner|
    "expected cost determiner to have a lodgement fee of #{fee_level}, got #{cost_determiner.lodgement_fee}"
  end
end

RSpec::Matchers.define :fail_to_determine_lodgement_fee do
  match do |cost_determiner|
    begin
      cost_determiner.lodgement_fee
      false
    rescue
      true
    end
  end

  failure_message do |cost_determiner|
    "expected cost determiner to raise an error when determining lodgement fee, but got '#{cost_determiner.lodgement_fee}'."
  end
end
