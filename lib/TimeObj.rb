require 'active_support/core_ext/object'

class TimeObj
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
		@start_method = start_method
		@end_method = end_method
	end

	def <=>(other)
		@data <=> other.data
	end

	def start
		if @data.class == Range
			@data.first
		else
			@data[@start_method]
		end
	end

	def end
		if @data.class == Range
			@data.last
		else
			@data[@start_method]
		end
	end

	def merge(params)
		if @data.respond_to? :attributes
			return @data.class.new(@data.attributes.merge(params))
		elsif @data.respond_to? :merge
			return @data.merge(params)
		end
		raise ArgumentError.new('Objects that are represented as times must respond to :attributes, :merge or be of class Range.')
	end

	def length
		start - self.end
	end

end