#!/usr/bin/env ruby

puts "@@senators = [nil]"
while x = gets.chomp
  arr = x.split "\t"
  puts "@@senators[#{arr[0]}] = {:name => '#{arr[1]}', :phone => '#{arr[2]}'}"
end
