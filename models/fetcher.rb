class StationFetcher

  attr_reader :stations
  API_URL = "http://citibikenyc.com/stations/json"
  STASH_PATH = "data/recent.json"

  def initialize
    request = Typhoeus.get(API_URL)
    if is_good?(request)
      json = request.options[:response_body]
      stash json
    else
      # if we can't download the json
      # use the most recently savedversion
      json = File.open(STASH_PATH).read
    end
    @stations = json_to_stations(json)
  end

  private

  def json_to_stations(json)
    MultiJson.load(json)["stationBeanList"].collect do |station|
      symbolify_keys(station)
    end
  end

  def symbolify_keys(hash)
    better_hash = {}
    hash.each do |k, v|
      better_hash[k.to_sym] = v
    end
    better_hash
  end

  def is_good? request
    request.options[:response_code] == 200
  end

  def stash json
    File.open(STASH_PATH, "w") do |f|
      f.write json
    end
  end

end