require 'rspec/expectations'

RSpec::Matchers.define :have_mapping_code do |mapping_code|
  match do |mapping_code_determiner|
    mapping_code_determiner.valid_for_determining_mapping_code? &&
      mapping_code_determiner.mapping_code == MappingCode.new(mapping_code)
  end

  failure_message do |mapping_code_determiner|
    "expected to get a mapping code of #{mapping_code}, got #{mapping_code_determiner.mapping_code}"
  end
end

RSpec::Matchers.define :fail_to_determine_mapping_code do
  match do |mapping_code_determiner|
    return false if mapping_code_determiner.valid_for_determining_mapping_code?

    begin
      mapping_code_determiner.mapping_code
      false
    rescue
      true
    end
  end

  failure_message do |mapping_code_determiner|
    "expected mapping code determiner to raise an error when determining mapping code, but got '#{mapping_code_determiner.mapping_code}'."
  end
end
