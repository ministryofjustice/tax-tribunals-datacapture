class AddHardshipReasonToTribunalCase < ActiveRecord::Migration[5.0]
  def change
    add_column :tribunal_cases, :hardship_reason, :string
  end
end
