class CreateMitarbeiter < ActiveRecord::Migration
  def change
    create_table :mitarbeiter do |t|
      t.string :kuerzel

      t.timestamps
    end
  end
end
