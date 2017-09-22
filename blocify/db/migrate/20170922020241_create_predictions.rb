class CreatePredictions < ActiveRecord::Migration
  def change
    create_table :predictions do |t|
      t.string :song
      t.integer :result

      t.timestamps null: false
    end
  end
end
