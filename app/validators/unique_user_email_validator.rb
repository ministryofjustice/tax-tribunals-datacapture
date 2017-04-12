class UniqueUserEmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unique = User.where(email: value).empty?
    record.errors.add(attribute, :not_unique) unless unique
  end
end
