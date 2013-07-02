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

    before '/stations' do
      fetcher = StationFetcher.new
      if fetcher.updated
        fetcher.stations.each do |station|
          s = Station.first_or_create({ :id => station[:id] })
          s.update(station)
        end
      end
    end

    get '/' do
      redirect "/stations"
    end

    get '/stations' do
      @stations = Station.all
      erb :'stations/list'
    end

    # on some level I get that this route should be a 
    # delete route and not a get route but I'm not sure
    # how to implement that exactly
    get '/stations/delete/:id' do
      Station.get(params[:id]).destroy
      redirect "/stations"
    end

    get '/stations/edit/:id' do
      @station = Station.get(params[:id])
      @properties = Station.properties
      erb :'stations/edit'
    end

    #  should be a put request but couldn't get it to work
    # not that this is working, either
    post '/stations/:id' do
      # what are these? they're confusing datamapper
      params.delete("splat")
      params.delete("captures")
      s = Station.first_or_create({ :id => params[:id] })
      s.update(params)
      redirect "/stations/#{params[:id]}"
    end

    get '/stations/:id' do
      @station = Station.get(params[:id])
      erb :'stations/show'
    end

  end
end



DataMapper.auto_upgrade!