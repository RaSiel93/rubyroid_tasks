require "ryba"

require 'optparse'

require "./lib/Damage"
require "./lib/UserGenerator"

require "./lib/GeneratorRecord"

module Generator
  def self.generate options
  	users = Set.new
	  factory = GeneratorRecord::Factory.factory options.location
	  users << factory.generate until users.size == options.count
  	users.map{ |user| Damage::execute(user, options.probability) }
  	users
  end
end