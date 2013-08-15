class CreateRegeln < ActiveRecord::Migration
  def change
    create_table :regeln do |t|
      t.string :name
      t.integer :zeitfenster
      t.integer :grenze_maximum
      t.integer :grenze_minimum
      t.boolean :ist_aktiv
      t.string :kommentar

      t.integer :sort_order
      t.integer :variable_id

      t.timestamps
    end
  end
end
