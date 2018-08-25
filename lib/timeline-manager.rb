require 'active_support/core_ext/object'
require 'TimeObj'

module TimelineManager
	class Timeline

		def initialize(times=[], start_method=:start, end_method=:end, time_diff=Proc.new { 1.day })
			@times = times.map { |t| t.class == TimeObj ? t : TimeObj.new(t, start_method, end_method) }
			@time_diff = time_diff
			@start_method = start_method
			@end_method = end_method
		end

		def data
			@times.map { |t| t.data }
		end

		def insert(time, start_method=:start, end_method=:end)
			# Produce a new Timeline where time's start through end is unique in @times.
			time = TimeObj.new(time, start_method, end_method)
			new_times = []
			@times.each do |t|
	      if t.start >= time.start && t.end <= time.end
	        # The new time covers the old one completely; remove it.
	      elsif t.start < time.start && t.end > time.end
	        # The new time splits the old one in half.
	        new_times << t.merge({"#{t.end_method}": time.start - @time_diff.call})
	        new_times << t.merge({"#{t.start_method}": time.end + @time_diff.call})
	      elsif t.start < time.start
	        # The new time cuts off the old time's end.
	        new_times << t.merge({"#{t.end_method}": time.start - @time_diff.call })
	      else
	        # The new time cuts off the old time's beginning.
	        new_times << t.merge({"#{t.start_method}": time.end + @time_diff.call })
	      end
	    end
	    new_times << time
	    Timeline.new(new_times, @start_method, @end_method, @time_diff)
		end

		def overlap(time, start_method=:start, end_method=:end)
			# Beginning and end overlap, but middle is replaced. 
			time = TimeObj.new(time, start_method, end_method)
			new_times = []
			@times.dup.each do |t|
		    if t.start > time.start && t.end < time.end
		      # The new time covers the old one completely; remove it.
		    elsif t.start <= time.start && t.end >= time.end
		      # The new time splits the old one in half.
		      if t.length > @time_diff
		        # The new time is more than one time_diff long
		        new_times << t.merge({"#{t.start_method}": time.end})
		        new_times << t.merge({"#{t.end_method}": time.start})
		      end
		    elsif t.start < time.start
		      # The new time cuts off the old time's end.
		      new_times << t.merge({"#{t.end_method}": time.start})
		    elsif t.start == time_start && time.end >= t.end
		      # The new time starts on the old time's start, but the new time continues past the time's end
		      new_times << t.merge({"#{t.end_method}": t.start})
		    else
		      # The new time cuts off the old time's beginning.
		      new_times << t.merge({"#{t.start_method}": time.end})
		    end
		  end
		  new_times << time
	    Timeline.new(new_times, @start_method, @end_method, @time_diff)
		end

		def overlay(time, start_method=:start, end_method=:end)
			# Simply add the new time to the time line; allows complete overlap.
			new_times << time
	    Timeline.new(new_times, @start_method, @end_method, @time_diff)
		end
	end
end
