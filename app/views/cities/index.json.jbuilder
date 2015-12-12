json.array!(@cities) do |city|
  json.extract! city, :id, :name, :locked, :stone, :wood, :population
  json.url city_url(city, format: :json)
end
