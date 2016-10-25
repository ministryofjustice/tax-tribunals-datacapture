class CreateTribunalCases < ActiveRecord::Migration[5.0]
  def change
    create_table :tribunal_cases, id: :uuid do |t|
      t.boolean :did_challenge_hmrc

      t.timestamps
    end
  end
end
