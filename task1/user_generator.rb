require "ryba"

require 'optparse'

require "./lib/Damage"
require "./lib/UserGenerator"

require "./lib/Generator"


class Options
	attr_reader :location 

	private

	def parse(args)


		options = {}
		OptionParser.new do |opts|
	  	opts.banner = "Usage: user_generator.rb [options]"

	 		opts.on("-l", "--location [:RU, :BY, :US]", "Location of generated users") do |loc|
	    	@location = loc
	  	end 

	  	opts.on("-c", "--count NUMBER", "Count of records") do |c|
	    	options[:count] = c.to_i
	  	end


	  	opts.on("-p", "--probability FLOAT_NUMBER", "Probability error in record") do |p|
	    	options[:probability] = p.to_f
	  	end
		end.parse!

		errors = []
		errors << "Not all options getted!" if (options).count != 3
		errors << "Wrong location of watermark. Aborted!" if options[:location].match("^BY$|^RU$|^EN$").nil?
		#errors << "Is not numberа. Aborted! #{options[:count]}" if options[:count].to_s != options[:count]
		
		# errors << "Unsupported format of watermark! Aborted!" if options[:mark_img].split('.')[-1].match("^gif$|^jpg$|^png$").nil?
		# errors << "Empty work directory. Aborted!" if !Dir.new(options[:work_directory]).any?

		if errors.any?
		  errors.each { |e| puts e }
		  exit(0)
		end

		options
	end
end

module Generator

  def self.generate options
  	users = Set.new
	  factory = Factory.factory options[:location]
	  users << factory.generate until users.size == options.count
  	users.map{ |user| Damage::execute(user, options[:probability]) }
  	users
  end
end


options = Options.new(ARGV)

if options.errors?
	puts ""
	exit(0)
end

options.count

p Generator::generate options