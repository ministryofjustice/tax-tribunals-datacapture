class NormalisedEmailType < ActiveRecord::Type::String
  # https://www.cs.sfu.ca/~ggbaker/reference/characters/#single
  UNICODE_QUOTES = "\u0060\u2018\u2019\u2032".freeze
  APOSTROPHE = "'".freeze

  # https://www.cs.sfu.ca/~ggbaker/reference/characters/#dash
  UNICODE_HYPHENS = "\u2010-\u2015".freeze
  HYPHEN = "-".freeze

  def cast(value)
    super(normalise(value))
  end

  private

  def normalise(value)
    value.to_s.strip.
        gsub(/[#{UNICODE_QUOTES}]/,  APOSTROPHE).
        gsub(/[#{UNICODE_HYPHENS}]/, HYPHEN)
  end
end
