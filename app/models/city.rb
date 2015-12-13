class City < ActiveRecord::Base
  has_many :buildings
  has_many :units
  validates :city_hash, uniqueness: true, presence: true
end
