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
      redirect "/stations"
    end

    get '/stations' do
      @stations = Station.all
      erb :'stations/list'
    end

    get '/stations/:id' do
      @station = Station.get(params[:id])
      erb :'stations/show'
    end

    # on some level I get that this route should be a 
    # delete route and not a get route but I'm not sure
    # how to implement that exactly
    get '/stations/delete/:id' do
      Station.get(params[:id]).destroy
      redirect "/stations"
    end

  end
end



DataMapper.auto_upgrade!