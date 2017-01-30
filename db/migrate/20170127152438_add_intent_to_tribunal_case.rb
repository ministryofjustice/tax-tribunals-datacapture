class AddIntentToTribunalCase < ActiveRecord::Migration[5.0]
  def change
    add_column :tribunal_cases, :intent, :string
  end
end
