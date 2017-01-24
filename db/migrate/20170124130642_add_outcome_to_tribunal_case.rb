class AddOutcomeToTribunalCase < ActiveRecord::Migration[5.0]
  def change
    add_column :tribunal_cases, :outcome, :string
  end
end
