class BaseForm
  include Virtus.model
  include ActiveModel::Validations

  def persisted?
    false
  end
end
