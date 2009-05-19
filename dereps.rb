#!/usr/bin/env ruby

require 'rubygems'
require 'sinatra'
require 'state-reps'

include StateReps

BILL = "House Bill 5"

get '/' do
  haml :index
end

post '/script' do
  @person = Person.new
  @person.address = params[:address]
  @person.city = params[:city]
  @person.state = params[:state]
  @person.zip9 = zip_9 @person
  @person.set_reps
  
  
  haml :script
end



use_in_file_templates!

__END__

@@ layout

%html
  %head
    %title= @title || "Find Your State Representatives"
  %body
    = yield
    %hr
    Copyright (c) 2009 Daniel Jackoway


@@ index

%h1= "Help Pass #{BILL}"

%p
  TODO Blurb about why HB 5 rocks.

%p
  First, we must determine your state representatives. To do so, please enter your address below. We promise not to record your address. It will only be used to determine your state legislative districts. 

%form{:action => '/script', :method => :post}
  %p
    %label Address
    %input{:type => 'textfield', :name => "address", :size => 50}
  %p
    %label City
    %input{:type => 'textfield', :name => "city", :size => 25}
    %label State
    -# thanks http://snippets.dzone.com/posts/show/375
    <select name="state"> 
    <option value="AL">Alabama</option> 
    <option value="AK">Alaska</option> 
    <option value="AZ">Arizona</option> 
    <option value="AR">Arkansas</option> 
    <option value="CA">California</option> 
    <option value="CO">Colorado</option> 
    <option value="CT">Connecticut</option> 
    <option value="DE" selected="selected">Delaware</option> 
    <option value="DC">District Of Columbia</option> 
    <option value="FL">Florida</option> 
    <option value="GA">Georgia</option> 
    <option value="HI">Hawaii</option> 
    <option value="ID">Idaho</option> 
    <option value="IL">Illinois</option> 
    <option value="IN">Indiana</option> 
    <option value="IA">Iowa</option> 
    <option value="KS">Kansas</option> 
    <option value="KY">Kentucky</option> 
    <option value="LA">Louisiana</option> 
    <option value="ME">Maine</option> 
    <option value="MD">Maryland</option> 
    <option value="MA">Massachusetts</option> 
    <option value="MI">Michigan</option> 
    <option value="MN">Minnesota</option> 
    <option value="MS">Mississippi</option> 
    <option value="MO">Missouri</option> 
    <option value="MT">Montana</option> 
    <option value="NE">Nebraska</option> 
    <option value="NV">Nevada</option> 
    <option value="NH">New Hampshire</option> 
    <option value="NJ">New Jersey</option> 
    <option value="NM">New Mexico</option> 
    <option value="NY">New York</option> 
    <option value="NC">North Carolina</option> 
    <option value="ND">North Dakota</option> 
    <option value="OH">Ohio</option> 
    <option value="OK">Oklahoma</option> 
    <option value="OR">Oregon</option> 
    <option value="PA">Pennsylvania</option> 
    <option value="RI">Rhode Island</option> 
    <option value="SC">South Carolina</option> 
    <option value="SD">South Dakota</option> 
    <option value="TN">Tennessee</option> 
    <option value="TX">Texas</option> 
    <option value="UT">Utah</option> 
    <option value="VT">Vermont</option> 
    <option value="VA">Virginia</option> 
    <option value="WA">Washington</option> 
    <option value="WV">West Virginia</option> 
    <option value="WI">Wisconsin</option> 
    <option value="WY">Wyoming</option>
    </select>
  %input{:type => "submit", :value => "Get Reps"}

@@ script

= @person.to_s
