class Konfiguration < ActiveRecord::Base
  attr_accessible :gruen1, :gruen2, :gruenorangerot_position, :orange1, :orange2, :rot1, :rot2, :type, :regel_id, :regel,  :mitarbeiter,  :mitarbeiter_ids

  belongs_to :regel
  has_and_belongs_to_many :mitarbeiter

  #def mitarbeiter_ids
  #  mitarbeiter.map(&:id)
  #end
  #
  #def mitarbeiter_ids=(ids)
  #
  #end

end