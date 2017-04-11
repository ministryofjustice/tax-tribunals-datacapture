class AddUserCasesRelationship < ActiveRecord::Migration[5.0]
  def change
    add_reference :tribunal_cases, :user, type: :uuid, foreign_key: true
  end
end
