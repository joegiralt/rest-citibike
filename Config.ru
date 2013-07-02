require './app'

fetcher = StationFetcher.new

fetcher.stations.each do |station|
  s = Station.first_or_create({ :id => station[:id] })
  s.update(station)
end

run Bikes::App
