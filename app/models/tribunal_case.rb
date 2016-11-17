class TribunalCase < ApplicationRecord
  composed_of :case_type,
    allow_nil:  true,
    mapping:    [%w(case_type value)]

  composed_of :dispute_type,
    allow_nil:  true,
    mapping:    [%w(dispute_type value)]

  composed_of :penalty_amount,
    allow_nil:  true,
    mapping:    [%w(penalty_amount value)]

  composed_of :lodgement_fee,
    allow_nil:  true,
    mapping:    [%w(lodgement_fee value)]
end
