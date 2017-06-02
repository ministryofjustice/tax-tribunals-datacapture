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
