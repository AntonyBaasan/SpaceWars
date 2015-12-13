class City < ActiveRecord::Base
  has_many :buildings
  validates :city_hash, uniqueness: true, presence: true
end
