class PenaltyLevel < ValueObject
  #
  # This class is used as both a store of potential options
  # to display to the user
  # And also instances of PenaltyLevel are saved on the tribunal_case, e.g.
  # tribunal_case.penalty_level = PenaltyLevel.new(:penalty_level_1)
  #

  LEVELS = [{
    name: PENALTY_LEVEL_1 = new(:penalty_level_1),
    lower_bound: -1,
    upper_bound: 100
  },
            {
              name: PENALTY_LEVEL_2 = new(:penalty_level_2),
              lower_bound: 100,
              upper_bound: 20_000
            },
            {
              name: PENALTY_LEVEL_3 = new(:penalty_level_3),
              lower_bound: 20_000,
              upper_bound: 99_999_999_999_999_999
            }].freeze

  def self.names
    LEVELS.map {|v| v[:name] }.map(&:to_s)
  end

  def self.lower_bound(level)
    bound(level, :lower_bound)
  end

  def self.upper_bound(level)
    bound(level, :upper_bound)
  end

  def self.bound(level, type)
    return unless names.include? level.to_s
    LEVELS.select {|v| v[:name].value == level.to_sym }[0][type]
  end
end