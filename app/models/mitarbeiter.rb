class Mitarbeiter < ActiveRecord::Base
  attr_accessible :kuerzel

  has_and_belongs_to_many :konfigurationen

end
