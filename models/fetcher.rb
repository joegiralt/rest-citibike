class StationFetcher

  attr_reader :stations, :updated
  API_URL = "http://citibikenyc.com/stations/json"
  STASH_PATH = "data/recent.json"
  RELAX_TIME = 300

  def initialize

    json = File.open(STASH_PATH).read
    data = MultiJson.load(json)

    if seconds_since_last_request(data) > RELAX_TIME
      puts "it's been long enough to send another request"
      @updated = true
      request = Typhoeus.get(API_URL)
      if is_good?(request)
        json = request.options[:response_body]
        stash json
        data = MultiJson.load(json)
      end
    else
      puts "Let's relax for a little while longer before making another request"
      @updated = false
    end
    @stations = data_to_stations(data)
  end

  private

  def seconds_since_last_request(data)
    Time.now - Time.parse(data["executionTime"])
  end

  def data_to_stations(data)
    data["stationBeanList"].collect do |station|
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