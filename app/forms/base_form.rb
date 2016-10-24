class BaseForm
  include Virtus.model
  include ActiveModel::Validations

  def to_key
    # Intentionally returns nil so the form builder picks up _only_
    # the class name to generate the HTML attributes.
    nil
  end

  def persisted?
    false
  end
end
