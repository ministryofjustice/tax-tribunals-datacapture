class TribunalCase < ApplicationRecord
  composed_of :case_type,
    allow_nil:  true,
    mapping:    [%w(case_type value)]

  composed_of :dispute_type,
    allow_nil:  true,
    mapping:    [%w(dispute_type value)]
end
