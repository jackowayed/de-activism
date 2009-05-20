#!/usr/bin/env ruby

module StateReps
require 'net/http'
require 'uri'
  def spacesToPlus(str)
    str = str.to_s
    arr = str.split(" ")
    str = ""
    arr.each{|x|
      str+=x
      str+="+"
    }
    str = str[0,str.length-1] if str.include?("+")
    return str
  end

  def spacesToHTML(str)
    str = str.to_s
    arr = str.split(" ")
    str = ""
    arr.each{|x|
      str+=x
      str+="&nbsp;"
    }
    str = str[0,str.length-1] if str.include?("+")
    return str
  end




  #format for files: Name \t Address \t City \t State \t Zip9 \t SD \t RD

  def putPeople(people)
    out = File.new("uufn2.txt", "w")
    people.each{|x|
      str = ""
      str<< x.name if x.name
      str<< "\t"
      str<< x.address if x.address
      str<< "\t"
      str<< x.city if x.city
      str<< "\t"
      str<< x.state if x.state
      str<< "\t"
      str<< x.zip9 if x.zip9
      str<< "\t"
      str<< x.sd if x.sd
      str<< "\t"
      str<< x.rd if x.rd
      out<< str
      out<< "\n"
    }
    out.close
  end


  def zip_9(person)
    begin
      url = URI.parse("http://zip4.usps.com/zip4/zcl_0_results.jsp?visited=1&pagenumber=0&firmname=&address2=#{spacesToPlus(person.address).upcase}&address1=&city=#{spacesToPlus(person.city).upcase}&state=#{spacesToPlus(person.state).upcase}&urbanization=&zip5=&submit.x=0&submit.y=0&submit=Find+ZIP+Code")
      #puts url
      response = Net::HTTP.get(url)
      
      page = response.to_s
      page = page[32000..-1]
      #puts page
      #regex = /#{spacesToHTML(person.city)}&nbsp;#{spacesToHTML(person.state)}&nbsp;\d\d\d\d\d-\d\d\d\d/i
      regex = /\d\d\d\d\d-\d\d\d\d/
      #regex = /Newark&nbsp;DE&nbsp;&nbsp;19711-2334/i
      #regex = /<br \/>/
      #puts regex
      #zipspot = (/#{spacesToHTML(person.address).upcase}#{spacesToHTML(person.city)}&nbsp;#{spacesToHTML(x.state)}&nbsp;\d\d\d\d\d-\d\d\d\d/ =~ page)
      zipspot = regex=~page
      zip = page[zipspot,10] if (zipspot)
      #puts zip
      zip
    rescue
      puts $!
      puts person.name
    end
  end

  def getZip9()

    #POST = "digg.com"
    #PORT = 80
    

    
    #Net::HTTP.start(HOST, PORT) do |http|
    people.each{|x|
      #  x = Person.new
      #  x.address="112 Great Circle Rd"
      #  x.city="Newark"
      #  x.state="DE"
      
      
      #request = Net::HTTP::Post.new(URI2,{"address1"=> x.address, "city"=> x.city, "state"=> x.state})
      #  request = Net::HTTP::Post.new(URI2, {"address2" => "112+Great+Circle+Rd", "city" => "Newark", "state" => "DE", "address1" => "", "zip5" => "", "visited" => "1", "pagenumber" => "0", "firmname"=>"", "urbanization" => "", "submit.x" => "0", "sumbit.y" => "0", "submit" => "Find+ZIP+Code"})
      
      
      
      #    uri2 = "/zip4/zcl_0_results.jsp?visited=1&pagenumber=0&firmname=&address2=#{spacesToPlus(x.address).upcase}&address1=&city=#{spacesToPlus(x.city).upcase}&state=#{spacesToPlus(x.state).upcase}&urbanization=&zip5=&submit.x=0&submit.y=0&submit=Find+ZIP+Code"
      #  request = Net::HTTP::Get.new(uri2)
      #    response = http.request(request)
      #response = Net::HTTP.get(URI.parse("zip4.usps.com/zip4/zcl_0_results.jsp?visited=1&pagenumber=0&firmname=&address2=#{spacesToPlus(x.address).upcase}&address1=&city=#{spacesToPlus(x.city).upcase}&state=#{spacesToPlus(x.state).upcase}&urbanization=&zip5=&submit.x=0&submit.y=0&submit=Find+ZIP+Code"))
      
      
      
      #page = Net::HTTP.post_form(URI.parse("zip4.usps.com/zip4/zcl_0_results.jsp"), {"address1"=> x.address, "city"=> x.city, "state"=> x.state})
      #uri2 = "/zip4/zcl_0_results.jsp?visited=1&pagenumber=0&firmname=&address2=#{spacesToPlus(x.address).upcase}&address1=&city=#{spacesToPlus(x.city).upcase}&state=#{spacesToPlus(x.state).upcase}&urbanization=&zip5=&submit.x=0&submit.y=0&submit=Find+ZIP+Code"
      #uri2 = "/popular/24hours"
      
      zip = zip_9 x
      x.zip9 = zip if zip
      
      #thanks to http://snakesgemscoffee.blogspot.com/2007/03/twittering-around.html
    }
    #end
    
    #  peoplestr = ""
    #  people.each{|x|
    #    peoplestr << x.writeOut()
    #    peoplestr << "\n"
    #  }
    #puts peoplestr
    
    putPeople() 
    

  end



  def getReps(people)
    count = 0
    people.each{|x|
      #  x = Person.new
      #  x.zip9 = "19711-2334"
      x.set_reps
    }
        #  puts x.sd
        #  puts x.rd
   putPeople(people)

  end


  def reps(person)
    begin
      url = URI.parse("http://www.votesmart.org/search.php?search=#{person.zip9}")
      response = Net::HTTP.get(url);
      spot = /State House/ =~ response
      #    puts spot
      response = response[spot..-1] if spot
      regex = /\d+/
      regex =~ response
      reps = {}
      #person.rd = $& if spot
      reps[:rd] = $& if spot
      spot = /State Senate/ =~response
      response = response[spot..-1] if spot
      regex =~ response
      reps[:sd] = $& if spot
      #person.sd = $& if spot
      #puts count += 1
      reps
    rescue
      puts $!
      puts person.name
      { :rd => 'fail', :sd => 'fail' }
    end
  end
end
class Person
  attr_accessor :name, :address, :city, :state, :zip9, :sd, :rd
  
  @name = ""
  @address = ""
  @city = ""
  @state = ""
  @zip9 = ""
  @sd = ""
  @rd = ""

  @@senators = [nil]
  @@senators[1] = {:name => 'Harris B McDowell', :phone => '302-656-2921'}
  @@senators[2] = {:name => 'Margaret Rose Henry', :phone => '302-425-4148'}
  @@senators[3] = {:name => 'Robert Marshall', :phone => '302-656-7261'}
  @@senators[4] = {:name => 'Michael S Katz', :phone => '302-731-1190'}
  @@senators[5] = {:name => 'Catherine Cloutier', :phone => '302-477-0554'}
  @@senators[6] = {:name => 'Liane Sorenson', :phone => '302-234-3303'}
  @@senators[7] = {:name => 'Patricia Blevins', :phone => '302-994-3501'}
  @@senators[8] = {:name => 'David Sokola', :phone => '302-239-2193'}
  @@senators[9] = {:name => 'Karen E Peterson', :phone => '302-999-7522'}
  @@senators[10] = {:name => 'Bethany Hall-Long', :phone => '302-378-8386'}
  @@senators[11] = {:name => 'Anthony J DeLuca', :phone => '302-737-4929'}
  @@senators[12] = {:name => 'Dorinda A Connor', :phone => '302-328-8944'}
  @@senators[13] = {:name => 'David B McBride', :phone => '302-322-6100'}
  @@senators[14] = {:name => 'Bruce Ennis', :phone => '302-653-7566'}
  @@senators[15] = {:name => 'Nancy Cook', :phone => '302-653-8725'}
  @@senators[16] = {:name => 'Colin Bonini', :phone => '302-678-5548'}
  @@senators[17] = {:name => 'Brian J Bushweller', :phone => '302-674-5442'}
  @@senators[18] = {:name => 'Gary Simpson', :phone => '302-422-3460'}
  @@senators[19] = {:name => 'Thurman Adams', :phone => '302-337-8281'}
  @@senators[20] = {:name => 'George H Bunting', :phone => '302-539-2229'}
  @@senators[21] = {:name => 'Robert Venables', :phone => '302-875-7826'}


  def readIn(str)
    arr=str.chomp.split("\t")
    @name = arr[0].to_s.chomp
    @address = arr[1].to_s.chomp
    @city = arr[2].to_s.chomp
    @state = arr[3].to_s.chomp
    @zip9 = arr[4].to_s.chomp
    @SD = arr[5].to_s.chomp
    @RD = arr[6].to_s.chomp
  end
  
  def writeOut()
    str = ""
    if (@name)
      str+=@name
      str+="\t"
    end
    if (@address)
      str+=@address
      str+="\t"
    end
    if (@city)
      str+=@city
      str+="\t"
    end
    if (@state)
      str+=@state
      str+="\t"
    end
    if (@zip9)
      str+=@zip9
      str+="\t"
    end
    if (@sd)
      str+=@sd
      str+="\t"
    end
    if (@rd)
      str+=@rd
    end
    return str.chomp;
  end
  def to_s
    self.writeOut
  end
  def set_reps
    r = reps self
    self.rd = r[:rd]
    self.sd = r[:sd]
    r
  end
  def senator
    @senator ||= @@senators[self.sd.to_i]
  end
  def senator_phone
    @senator_phone ||= senator[:phone]
  end
  def senator_name
    @senator_name ||= senator[:name]
  end
  def full_address
    [self.address, self.city, self.state] * ', '
  end
end
