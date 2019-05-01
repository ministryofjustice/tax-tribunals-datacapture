class AddNeedSupportToTribunalCase < ActiveRecord::Migration[5.0]
  def change
    add_column :tribunal_cases, :need_support, :string
  end
end
