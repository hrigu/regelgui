class CreateVariablen < ActiveRecord::Migration
  def change
    create_table :variablen do |t|
      t.string :name

      t.timestamps
    end
  end
end
