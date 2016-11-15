class TribunalCase < ApplicationRecord
  composed_of :case_type,
    class_name: 'CaseType',
    allow_nil:  true,
    mapping:    [%w(case_type value)]

  def self.case_type_values
    CaseType.values
  end
end
