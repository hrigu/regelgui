class Regel < ActiveRecord::Base
  attr_accessible :grenze_maximum, :grenze_minimum, :ist_aktiv, :kommentar, :name, :variable_id, :zeitfenster, :type, :variable
  belongs_to :variable
  has_many :konfigurationen

end