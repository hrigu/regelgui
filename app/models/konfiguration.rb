class Konfiguration < ActiveRecord::Base
  attr_accessible :type, :regel_id, :regel,  :mitarbeiter,  :mitarbeiter_ids
  attr_accessible :gruen1, :gruen2, :orange1, :orange2, :rot1, :rot2
  attr_accessible :gruenorangerot_position, :gruenorangerot_position_100


  belongs_to :regel
  has_and_belongs_to_many :mitarbeiter


  def gruenorangerot_position_100
    self.gruenorangerot_position.nil? ? nil: self.gruenorangerot_position / 30
  end

  def gruenorangerot_position_100=(value)
    self.gruenorangerot_position = value * 30 if value
  end

end