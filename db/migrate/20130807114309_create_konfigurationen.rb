class CreateKonfigurationen < ActiveRecord::Migration
  def change
    create_table :konfigurationen do |t|
      t.string :type       #GruenOrangeRotKonfiguration oder PositionKonfiguration
      t.string :auspraegung #minimieren, maximieren oder einschraenken
      t.integer :gruen_untere_grenze
      t.integer :orange_untere_grenze
      t.integer :rot_untere_grenze
      t.integer :gruen_obere_grenze
      t.integer :orange_obere_grenze
      t.integer :rot_obere_grenze
      t.integer :gruenorangerot_position
      t.integer :regel_id

      t.timestamps
    end
    create_table :konfigurationen_mitarbeiter do |t|
      t.belongs_to :konfiguration
      t.belongs_to :mitarbeiter
    end

  end
end
