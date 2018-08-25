require 'active_support/core_ext/object'

class TimeObj
	# An interface to deal with passed-in time objects which
	# may have a variety of interfaces. 

	include Comparable

	attr_reader :data
	attr_reader :start_method
	attr_reader :end_method

	def initialize(data, start_method=:start, end_method=:end)
		if data.respond_to? :each
			@data = data
		else
			@data = [data]
		end
		if @data.class == Range || @data.class == Array
			start_method = :first
			end_method = :last
		end
		@start_method = start_method
		@end_method = end_method
	end

	def <=>(other)
		@data <=> other.data
	end

	def start
		@data[@start_method]
	end

	def end
		@data[@start_method]
	end

	def merge(params)
		if @data.respond_to? :attributes
			return @data.class.new(@data.attributes.merge(params))
		elsif @data.respond_to? :merge
			return @data.merge(params)
		end
		raise ArgumentError.new('Objects that are represented as times must respond to :attributes or :merge.')
	end

	def duration
		start - self.end
	end
end
