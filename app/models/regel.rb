class Regel < ActiveRecord::Base
  attr_accessible :grenze_maximum, :grenze_minimum, :ist_aktiv, :kommentar, :name, :variable_id, :zeitfenster, :type
  belongs_to :variable
  has_many :konfigurationen

end


class RegelMitZeitfenster < Regel

end

class RegelOhneZeitfenster < Regel

end
