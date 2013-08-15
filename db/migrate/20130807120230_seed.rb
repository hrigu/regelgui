# -*- encoding : utf-8 -*-
class Seed < ActiveRecord::Migration

  @@kuerzel = ["Franz", "Hans", "Pesche", "Vroni", "Vreni", "Ruedi", "Aschi", "Tessä", "Rita", "Lisbeth", "Küre", "Heiri", "Frida", "Schämpu"]
  @@variablen = ["Anzahl D1"] #"Anzahl Blöcke mit 7 x Dienst D1", "Anzahl arbeitsfreie Tage", "Anzahl D1 vier mal hintereinander", "Anzahl Spätdienste (D3, On3)", "3er Dienst: Nach 2 oder mehr 3er Diensten mindestens 3 Tage frei"]

  def up

    @@kuerzel.each do |k|
      Mitarbeiter.create(kuerzel: k)
    end
    @@variablen.each do |k|
      Variable.create(name: k)
    end

    #Regel ohne Zeitfenster
    regel1 = Regel.create(sort_order: 1, ist_aktiv: true, zeitfenster: nil, variable: Variable.where(name: "Anzahl D1").first)

    #Konfigurationen
    ## gruenorangerot
    ### Den Wert langsam minimieren
    ### Den Wert langsam maximieren
    ### Den Bereich des Wertes langsam einscrhänken
    ## position
    ### An einem bestimmten Punkt...
    ### An einem bestimmten Punkt...


    #Regel mit Zeitfenster und Grenze minimum
    r = Regel.create(name: "Innerhalb von 5 Tage mindestens 1 D1", sort_order: 2, ist_aktiv: true, zeitfenster: 5, grenze_minimum: 1, variable: Variable.where(name: "Anzahl D1").first)
    r = Regel.create(name: "Innerhalb von 10 Tage höchstens 4 D1", sort_order: 3, ist_aktiv: true, zeitfenster: 10, grenze_maximum: 4, variable: Variable.where(name: "Anzahl D1").first)

    #Konfigurationen
    #- PositionKonfiguration "Relevanz einstellen" -> Slider "An einem bestimmten Punkt die Anzahl Verletzungen minimieren"
    #PositionKonfiguration.create(gruenorangerot_position: 1000, regel: regel1, mitarbeiter: [Mitarbeiter.first, Mitarbeiter.all[2]])

    #Maximal 7 Tage am Stück arbeiten variable: "anzahl tage mit Arbeit" zeitfenster: 8, grenze_maximum: 7
    #- PositionKonfiguration "Relevanz einstellen" -> Slider "An einem bestimmten Punkt die Anzahl Verletzungen minimieren"


  end

  def down
    Mitarbeiter.delete_all
    Variable.delete_all
    Regel.delete_all
    Konfiguration.delete_all
  end
end
