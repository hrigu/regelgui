class Konfiguration < ActiveRecord::Base
  attr_accessible :gruen1, :gruen2, :gruenorangerot_position, :orange1, :orange2, :rot1, :rot2, :type, :regel_id, :regel,  :mitarbeiter

  belongs_to :regel
  has_and_belongs_to_many :mitarbeiter
end