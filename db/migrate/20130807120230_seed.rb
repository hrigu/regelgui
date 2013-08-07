# -*- encoding : utf-8 -*-
class Seed < ActiveRecord::Migration

  @@kuerzel = ["Franz", "Hans", "Pesche", "Vroni", "Vreni", "Ruedi", "Aschi", "Tessä", "Rita", "Lisbeth", "Küre", "Heiri", "Frida", "Schämpu"]
  @@variablen = ["Anzahl D1", "Anzahl Blöcke mit 7 x Dienst D1", "Anzahl arbeitsfreie Tage", "Anzahl D1 vier mal hintereinander", "Anzahl Spätdienste (D3, On3)", "3er Dienst: Nach 2 oder mehr 3er Diensten mindestens 3 Tage frei"]

  def up

    @@kuerzel.each do |k|
      Mitarbeiter.create(kuerzel: k)
    end
    @@variablen.each do |k|
      Variable.create(name: k)
    end

    #Regeln
    r = RegelMitZeitfenster.create(name: "Möglichst 2 D1", ist_aktiv: true, zeitfenster: 1, grenze_minimum: 3, variable: Variable.where(name: "Anzahl D1").first)

    #Konfigurationen
    PositionKonfiguration.create(gruenorangerot_position: 1000, regel: r, mitarbeiter: [Mitarbeiter.first, Mitarbeiter.all[2]])

  end

  def down
    Mitarbeiter.delete_all
    Variable.delete_all
    Regel.delete_all
    Konfiguration.delete_all
  end
end
