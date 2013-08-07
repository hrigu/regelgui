class Variable < ActiveRecord::Base
  attr_accessible :name
  has_many :regeln
end
