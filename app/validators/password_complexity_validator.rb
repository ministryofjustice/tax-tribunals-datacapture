class PasswordComplexityValidator < ActiveModel::Validator
  PATTERNS = {
    digit: /\p{Digit}/,
    lower: /\p{Lower}/,
    upper: /\p{Upper}/,
    symbol: /(?=.*?[#?!@$%^&*-])/,
  }.freeze

  def validate(record)
    PATTERNS.keys.each do |key|
      # display one error message at the time
      return unless record.errors[:password].empty?

      pattern = Regexp.new PATTERNS[key]

      unless (record.password).scan(pattern).size >= 1
        record.errors.add :password, :"password.complexity.#{key}"
      end
    end
  end
end
