#!/usr/bin/env ruby

require 'rubygems'
require 'sinatra'
require 'vendor/gems/state-reps-0.1.5/lib/state-reps'

include StateReps

BILL = "House Bill 5"

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

post '/script' do
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

  return haml :index if @errors


  @person.zip9 = param_load(params[:zip9]) || zip_9(@person)

  unless @person.zip9
    @errors = "We had an error getting your 9-digit zip code. Please use link to manually find it."
    return haml :index
  end

  @person.set_reps

  unless @person.sd
    @errors = "We had some issue finding your state senator. Sorry about that! Trying once more now and then again in 5 or 10 minutes might be all it takes. Otherwise, please send us feedback"
    return haml :index
  end
  
  
  haml :script
end



use_in_file_templates!

__END__


@@ index

%h1= BILL

- if @errors
  #errors
    = @errors

%p
  Delaware House Bill 5 proposes to ban discrimination based on sexual orientation. It passed the state House of Representatives convincingly with a 26-14 margin. Currently, it is stuck in the Senate Executive Committee. 
%p
  Since the bill will probably not leave committee through regular means, state Senators need to sign a petition to bring it to the Senate floor.
%p
  This site will quickly and securely allow you to determine your state Senator and his or her phone number and give you a sample script to use when encouraging him or her to sign the petition. 

%p
  First, we must determine your state representatives. To do so, please enter your address below. We will not record your address. It will only be used to determine your state Senator.

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
  .phonenum OR
  %hr{:width => '500px', :style => "margin-left: 0"}
  %p
    If you are uncomfortable providing your address, simply enter your 9-digit zip code below. Go
    %a{:href => "http://zip4.usps.com/zip4/"} here
    to determine your 9-digit zip code if you do not know it.
  %p
    %label 9-digit Zip Code
    %input{:type => "textfield", :name => "zip9", :length => 10, :size => 10}
  %input{:type => "submit", :value => "Continue"}

@@ script

%h1 Call Your Senator


%p
  Now, please call your state senator, Senator
  = @person.senator_name
  , to ask him/her to sign the petition to get
  = BILL
  out of committee.

%p
  Below is your senator's phone number, followed by a sample script to use when talking to him or her.

%p
  Call
  %span.phonenum= @person.senator_phone

%h2 Script

%p
  Dear Senator 
  =precede @person.senator_name do
    \:

%p
  My name is 

  = succeed '. I live at' do
    %span.bold&== <your name>
  = succeed ', and I am calling today to ask for your support for House Bill 5.' do
    - if @person.address
      = @person.full_address
    - else
      %span.bold&== <your address>


%p
  HB 5 is a bill that would prohibit discrimination on the basis of sexual orientation in areas such as employment and housing. This bill is important to me because I feel that it is important to end this kind of unfair discrimination.

%p
  HB 5 passed by a large margin in the House of Representatives, but is stuck in the Senate Executive Committee.

%p
  Senator David Sokola is passing a petition around to pull the bill onto the senate floor for a vote. I hope that you have already signed the petition, and if not, that you will sign it by June 2nd, Petition Day for HB5. We have been patiently waiting for 10 years to get this legislation to the senate floor. 

%p
  Can I count on your support in petitioning HB5 out of committee?
