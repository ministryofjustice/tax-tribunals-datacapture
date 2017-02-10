class AddNavigationStackToTribunalCase < ActiveRecord::Migration[5.0]
  def change
    add_column :tribunal_cases, :navigation_stack, :string, array: true, default: []
  end
end
