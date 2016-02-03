class City < ActiveRecord::Base
  has_many :buildings
  has_many :units
  validates :city_hash, uniqueness: true, presence: true
  validates_length_of :name, :minimum => 1, :maximum => 25, :allow_blank => false
end
