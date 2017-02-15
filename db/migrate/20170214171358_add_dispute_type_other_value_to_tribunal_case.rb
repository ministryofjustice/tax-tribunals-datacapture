class AddDisputeTypeOtherValueToTribunalCase < ActiveRecord::Migration[5.0]
  def change
    add_column :tribunal_cases, :dispute_type_other_value, :string
  end
end
