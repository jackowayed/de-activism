#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'

require 'sinatra'
require 'state-reps'
require 'haml'

BILL = "Civil Union and Equality Act of 2011"

SHORT_BILL = "SB 30"

REPS = StateReps.new ENV['VOTESMART_API_KEY']


# in:
# district \t [S]ponsor, [C]osponsor, or '' \t phone 1 \t phone 2
def read_data(filename)
  data = File.readlines(filename).map{|line| line.chomp.split("\t"). map{|field| field == "" ? nil : field}}
  data.map do |line|
    {:district => line[0], :sponsorship => line[1], :phone1 => line[2], :phone2 => line[3]}
  end
end

SENATORS = read_data 'data/senate-phone.txt'
REPRESENTATIVES = read_data 'data/house-phone.txt'

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
    @errors = "If you don't provide a 9-digit zip code, you must provide your address, city, and state" unless address && city && state
  end

  return haml(:index) if @errors


  zip9 = param_load(params[:zip9]) || REPS.zip_9(:address => address, :city => city, :state => state)

  unless zip9
    @errors = "We had an error getting your 9-digit zip code. Please use link to manually find it."
    return haml(:index)
  end

  s, r = REPS.sd_and_rd zip9
  @sd = s.keys.first.to_i
  @rd = r.keys.first.to_i
  @senator = s.values.first
  @rep = r.values.first
  @sen_phone1 = SENATORS[@sd - 1][:phone1]
  @sen_phone2 = SENATORS[@sd - 1][:phone2]
  @rep_phone1 = REPRESENTATIVES[@rd - 1][:phone1]
  @rep_phone2 = REPRESENTATIVES[@rd - 1][:phone2]
  @sen_sponsorship = SENATORS[@sd - 1][:sponsorship]
  @rep_sponsorship = REPRESENTATIVES[@rd - 1][:sponsorship]
  puts @rep_sponsorship
  haml :call
end
