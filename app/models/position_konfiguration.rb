class PositionKonfiguration < Konfiguration
  attr_accessible :gruenorangerot_position_100

  def gruenorangerot_position_100
    self.gruenorangerot_position / 30
  end

  def gruenorangerot_position_100=(value)
    self.gruenorangerot_position = value * 30
  end


end