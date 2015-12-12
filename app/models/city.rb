class City < ActiveRecord::Base
  validates :city_hash, uniqueness: true, presence: true
end
