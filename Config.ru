require './app'

fetcher = StationFetcher.new

if fetcher.updated
  fetcher.stations.each do |station|
    s = Station.first_or_create({ :id => station[:id] })
    s.update(station)
  end
end


run Bikes::App
