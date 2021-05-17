class CreateBackupNoas < ActiveRecord::Migration[6.0]
  def change
    create_table :backup_noas do |t|
      t.string :collection_ref
      t.string :folder
      t.string :filename
      t.text   :data
      t.integer :attempts

      t.timestamps
    end
  end
end
