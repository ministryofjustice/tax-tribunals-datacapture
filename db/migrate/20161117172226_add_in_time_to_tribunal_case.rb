class AddInTimeToTribunalCase < ActiveRecord::Migration[5.0]
  def change
    add_column :tribunal_cases, :in_time, :string
  end
end
