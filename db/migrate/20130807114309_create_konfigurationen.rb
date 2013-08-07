class CreateKonfigurationen < ActiveRecord::Migration
  def change
    create_table :konfigurationen do |t|
      t.integer :gruen1
      t.integer :orange1
      t.integer :rot1
      t.integer :gruen2
      t.integer :orange2
      t.integer :rot2
      t.integer :gruenorangerot_position
      t.string :type
      t.integer :regel_id

      t.timestamps
    end
  end

  def change
    create_table :konfiguration_mitarbeiter do |t|
      t.belongs_to :konfiguration
      t.belongs_to :mitarbeiter
    end
  end

end
