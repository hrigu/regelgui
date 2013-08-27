module Regel
  class Konfigurationstyp < ActiveRecord::Base
    attr_accessible :schluessel, :name

    has_many :konfiguratrionen

    validates_uniqueness_of :name, :schluessel

    GRUENORANGEROT = "GRUENORANGEROT"
    POSITION = "POSITION"


    def self.gruenorangerot
      Konfigurationstyp.where(schluessel: Konfigurationstyp::GRUENORANGEROT).first
    end

    def self.position
      Konfigurationstyp.where(schluessel: Konfigurationstyp::POSITION).first
    end

    def self.konfigurationstyp_for schluessel
      Konfigurationstyp.where(schluessel: schluessel).first
    end

  end
end