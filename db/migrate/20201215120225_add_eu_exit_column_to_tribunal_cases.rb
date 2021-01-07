class AddEuExitColumnToTribunalCases < ActiveRecord::Migration[6.0]
  def change
    add_column :tribunal_cases, :eu_exit, :boolean
  end
end
