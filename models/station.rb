class Station
  include DataMapper::Resource 
  property :id,                    Serial
  property :citybikeid,            Integer
  property :stationName,           Text
  property :availableDocks,        Integer
  property :totalDocks,            Integer
  property :latitude,              Float
  property :longitude,             Float
  property :statusValue,           Text
  property :statusKey,             Text
  property :availableBikes,        Text
  property :stAddress1,            Text
  property :stAddress2,            Text
  property :city,                  Text
  property :postalCode,            Text
  property :location,              Text
  property :altitude,              Text
  property :testStation,           Boolean
  property :lastCommunicationTime, DateTime
  property :landMark,              Text
  property :created_at,            DateTime
  property :updated_at,            DateTime
end

