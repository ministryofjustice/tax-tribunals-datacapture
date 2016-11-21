class AddLatenessReasonToTribunalCase < ActiveRecord::Migration[5.0]
  def change
    add_column :tribunal_cases, :lateness_reason, :text
  end
end
