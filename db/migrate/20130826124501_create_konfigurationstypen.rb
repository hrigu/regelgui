class CreateKonfigurationstypen < ActiveRecord::Migration

  def change
    create_table :konfigurationstypen do |t|
      t.string "schluessel", :limit => 45, :null => false
      t.string "name", :limit => 45, :null => false
    end
  end

end
