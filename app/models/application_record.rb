class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.has_value_object(value_object, constructor: nil)
    composed_of value_object,
      allow_nil:   true,
      mapping:     [[value_object.to_s, 'value']],
      constructor: constructor
  end
end
