# Timeline Manager

TimelineManager::Timeline is a class that helps order and transform grouped temporal data.

## Synopsis

```
require 'date'
require 'timeline-manager'

events = [

	{
		start: DateTime.now,
		end: DateTime.now + 7
	},
	{
		start: DateTime.now + 8,
		end: DateTime.now + 10
	}
]

timeline = TimelineManager::Timeline.new(events)

# Insert a new object, where the other object's times do not overlap with this new object's time.

altered_timeline = timeline.insert({
	start: DateTime.now + 2,
	end: DateTime.now + 4
})

puts altered_timeline.data

# => [
	{
		start: DateTime.now,
		end: DateTime.now + 1
	},
	{
		start: DateTime.now + 2,
		end: DateTime.now + 4
	},
	{
		start: DateTime.now + 5,
		end: DateTime.now + 7
	},
	{
		start: DateTime.now + 8,
		end: DateTime.now + 10
	}
]

# The original timeline is unaltered.

puts timeline.data

# => [
	{
		start: DateTime.now,
		end: DateTime.now + 7
	},
	{
		start: DateTime.now + 8,
		end: DateTime.now + 10
	}
]
```

## Examples

`TimelineManager::Timeline` is a class that helps order and transform temporal data.

For example, the simplest method is `overlay(obj)`. This method will perform no checks on any other object in the `Timeline` and simply add `obj` to the `times` in the `Timeline`

```
require 'date'
require 'timeline-manager'

timeline = TimelineManager::Timeline.new
timeline = timeline.overlay {start: DateTime.now, end: DateTime.now + 1}

puts timeline.data

# => [
	{
		start: DateTime.now,
		end: DateTime.now + 1
	}
]

timeline = timeline.overlay {start: DateTime.now, end: DateTime.now

puts timeline.data

# => [
	{
		start: DateTime.now,
		end: DateTime.now
	},
	{
		start: DateTime.now,
		end: DateTime.now + 1
	}
]
```

`insert(obj)`, however, does care about the times occupied by the other data when adding a new object to `times`:

```
require 'date'
require 'timeline-manager'

timeline = TimelineManager::Timeline.new
timeline = timeline.overlay {start: DateTime.now, end: DateTime.now + 7}

puts timeline.data

# => [
	{
		start: DateTime.now,
		end: DateTime.now + 7
	}
]

timeline = timeline.insert {start: DateTime.now + 2, end: DateTime.now + 4

puts timeline.data

# => [
	{
		start: DateTime.now,
		end: DateTime.now + 1
	},
	{
		start: DateTime.now + 2
		end: DateTime.now + 4
	},
	{
		start: DateTime.now + 5
		end: DateTime.now + 7
	}
]
```

When `insert`ing, `Timeline` will change the `start` and `end` of the other times in `times` such that the other `start` and `end` times do not overlap with the new object's `start` and `end`.

## Usage

`TimelineManager::Timeline.new([events, start_method, end_method, time_diff])`

* events
	
	The objects to be sorted, ordered, manipulated, etc. The objects should have a some way of accessing a start time and an end time, see `start_method` and `end_method`.

	Defaults to `[]`.

* start_method

	The attribute accessor for the start time of your data. 

	Defaults to `:start`.

* end_method
	
	The attribute accessor for the end time of your data. 

	Defaults to `:end`.

* time_diff 

	A Proc that returns the amount of time to move other time objects around. The Proc will be interpreted in a context that has ActiveSupport available.

	Defaults to `Proc.new { 1.day }`

`TimelineManager::Timeline.data`

Returns the data in its original form, potentially modified if other methods were used.

`TimelineManager::Timeline.insert`

todo

`TimelineManager::Timeline.overlap`

todo

`TimelineManager::Timeline.overlay`

todo

## Installation

Simply download the gem `timeline-manager` (perhaps with bundler -- `bundler install timeline-manager`), `require timeline-manager` and then instantiate: `timeline = TimelineManager::Timeline.new`
