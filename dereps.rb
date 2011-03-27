#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'

require 'sinatra'
require 'state-reps'
require 'haml'

BILL = "Civil Union and Equality Act of 2011"

SHORT_BILL = "SB 30"

REPS = StateReps.new ENV['VOTESMART_API_KEY']

helpers do
  def param_load(param)
    param && !param.empty? ? param : nil
  end
  def zip9?(zip)
    /\d{5}-\d{4}/ =~ zip
  end
end

get '/' do
  haml :index
end

post '/call' do
  address = param_load params[:address]
  city = param_load params[:city]
  state = param_load params[:state]
  @errors = nil
  if param_load params[:zip9]
    @errors = "9-digit zip must be 5 digit, followed by a '-', followed by 4 digits" unless zip9? params[:zip9]
  else
    @errors = "If you don't provide a 9-digit zip code, you must provide your address, city, and state" unless @person.address && @person.city && @person.state
  end

  return haml(:index) if @errors


  zip9 = param_load(params[:zip9]) || REPS.zip9(:address => address, :city => city, :state => state)

  unless zip9
    @errors = "We had an error getting your 9-digit zip code. Please use link to manually find it."
    return haml(:index)
  end

  s, r = REPS.sd_and_rd zip9
  @sd = s.keys.first
  @rd = r.keys.first
  @senator = s.values.first
  @rep = r.values.first
  
  haml :call
end
