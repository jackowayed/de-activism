#!/usr/bin/env ruby

require 'rubygems'
require 'sinatra'
require 'state-reps'
require 'haml'

include StateReps

BILL = "House Bill 5 or Senate Bill 121"

SHORT_BILL = "HB 5 and SB 121"

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
  @person = Person.new
  @person.address = param_load params[:address]
  @person.city = param_load params[:city]
  @person.state = param_load params[:state]
  @errors = nil
  if param_load params[:zip9]
    @errors = "9-digit zip must be 5 digit, followed by a '-', followed by 4 digits" unless zip9? params[:zip9]
  else
    @errors = "If you don't provide a 9-digit zip code, you must provide your address, city, and state" unless @person.address && @person.city && @person.state
  end

  return haml(:index) if @errors


  @person.zip9 = param_load(params[:zip9]) || zip_9(@person)

  unless @person.zip9
    @errors = "We had an error getting your 9-digit zip code. Please use link to manually find it."
    return haml(:index)
  end

  @person.set_reps

  unless @person.sd
    @errors = "We had some issue finding your state senator. Sorry about that! Trying once more now and then again in 5 or 10 minutes might be all it takes. Otherwise, please send us feedback"
    return haml(:index)
  end
  
  
  haml :call
end
