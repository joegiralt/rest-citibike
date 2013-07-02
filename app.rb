require 'sinatra'
require 'data_mapper'
require 'dm-sqlite-adapter'
require './models/station'
require './models/fetcher'
require 'debugger'
require 'multi_json'
require 'typhoeus'

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/citibike.db")

module Bikes
  class App < Sinatra::Base
    get '/' do
      @stations = Station.all
      erb :'stations/list'
    end
  end
end



DataMapper.auto_upgrade!