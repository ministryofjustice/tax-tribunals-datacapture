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

  composed_of :in_time,
    allow_nil:  true,
    mapping:    [%w(in_time value)]

  def cost_task_completed?
    lodgement_fee?
  end

  def lateness_task_completed?
    return false unless cost_task_completed? && in_time?
    in_time.eql?(InTime::YES) || lateness_reason?
  end
end
