module Regel
  class Konfiguration < ActiveRecord::Base
    attr_accessible :typ, :auspraegung
    attr_accessible :id, :name
    attr_accessible :regel_id, :regel, :mitarbeiter, :mitarbeiter_ids

    attr_accessible :gruen_untere_grenze, :orange_untere_grenze, :rot_untere_grenze,
                    :gruen_obere_grenze, :orange_obere_grenze, :rot_obere_grenze
    attr_accessible :gruenorangerot_position, :gruenorangerot_position_100


    belongs_to :regel
    has_and_belongs_to_many :mitarbeiter
    belongs_to :konfigurationstyp


    validates_presence_of :konfigurationstyp


    def gruenorangerot_position_100
      self.gruenorangerot_position.nil? ? nil : self.gruenorangerot_position / 30
    end

    def gruenorangerot_position_100=(value)
      self.gruenorangerot_position = value * 30 if value
    end

    def typ
      konfigurationstyp.schluessel
    end

    def typ= schluessel
      self.konfigurationstyp = Konfigurationstyp.konfigurationstyp_for schluessel
    end

  end
end