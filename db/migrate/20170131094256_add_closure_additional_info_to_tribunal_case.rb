class AddClosureAdditionalInfoToTribunalCase < ActiveRecord::Migration[5.0]
  def change
    add_column :tribunal_cases, :closure_additional_info, :text
  end
end
