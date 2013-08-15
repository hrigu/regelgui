# -*- encoding : utf-8 -*-


###
#
# Regel mit Zeitfenster
#  - Kann GruenOrangeRotPositionKonfigurationen haben falls ihr Zeitfenster 1 ist.
#    - ?? Welche Ausprägungen? (minimieren, maximieren, langsam einschränken)
#  - Kann Positionskonfigurationen haben
#    - ?? Falls grenze_max :
# Regel ohne Zeitfenster (immer pro Plan)
#  - Hat GruenOrangeRotPostionKonfigurationen
#  - PositionsKonfigurationen
#
###
class Regel < ActiveRecord::Base


  attr_accessible :ist_aktiv, :kommentar, :variable_id, :variable
  attr_accessible :sort_order
  attr_accessible :zeitfenster
  attr_accessible :name # ist gesetzt für Regeln mit Zeitfenster
  attr_accessible :grenze_maximum, :grenze_minimum

  belongs_to :variable
  has_many :konfigurationen


  include RankedModel
  ranks :sort_order#TODO , with_same: :mandant_id

  #
  # zählbar falls die Regel KEIN Zeitfenster hat oder ein Zeitfenster von 1 hat
  # Zählbare Regeln können gruen_orange_rot Konfigurationen haben
  #
  def ist_zaehlbar
    if zeitfenster.nil? || zeitfenster == 1
      true
    else
      false
    end
  end

  #
  # für Regeln mit Zeitfenster das Feld in der DB, für die anderen: Der Variablenname
  #
  def name
    zeitfenster.nil? ? variable.name : read_attribute(:name)
  end

end