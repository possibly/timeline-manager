# Timeline Manager

A Ruby gem that helps order and transform grouped temporal data.

## Synopsis

Consider these time lines.

```
<---- time ---->

Time A: |----------|
Time B:             |----->
Time C:     |---------|
```

Inserting Time C into Time A and B:

```
Time A: |---|
Time B:                 |-->
Time C:      |---------|
```

Overlaying Time C into Time A and B:
```
Time A: |----------|
Time B:            |----->
Time C:     |---------|
```

Overlapping Time C Into Time A and B:
```
Time A: |---|
Time B:               |--->
Time C:     |---------|
```

Splitting Time C Into Time A and B:
```
Time A: |---|
Time B:               |--->
Time C:     
```

## Examples

`TimelineManager::Timeline` is the class that helps order and transform temporal data.

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

timeline = timeline.overlay {start: DateTime.now, end: DateTime.now}

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

timeline = timeline.insert {start: DateTime.now + 2, end: DateTime.now + 4}

puts timeline.data

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
	}
]
```

When `insert`ing, `Timeline` will change the `start` and `end` of the other times in `times` such that the other `start` and `end` times do not overlap with the new object's `start` and `end`.

## Usage

### TimelineManager::Timeline.new([events, time_diff, start_method, end_method, post_delete, post_create, post_update])

Note that every parameter but `events` is a named parameter, and must be specified when passing in arguments. Ordered arguments beyond `events` are ignored.

* events
	
	The objects to be sorted, ordered, manipulated, etc. The objects should have a some way of accessing a start time and an end time, see `start_method` and `end_method`. Structure of objects is expected to be hash-like.

	Defaults to `[]`.

* time_diff 

	A Proc that returns the amount of time to move other time objects around. The Proc will be interpreted in a context that has ActiveSupport available.

	Defaults to `Proc.new { 1.day }`

* start_method

	The attribute accessor for the start time of your data. 

	Defaults to `:start`.

* end_method
	
	The attribute accessor for the end time of your data. 

	Defaults to `:end`.

* post_delete

	A method, proc or lambda to call after a passed in event is removed from the Timeline. Good for side effects, like logging or updating a database.

* post_create

	A method, proc or lambda to call after the new, passed in event is added to the Timeline. Good for side effects, like logging or updating a database.

* post_update

	A method, proc or lambda to call after a passed in event's `start` or `end` times have been updated. Good for side effects, like logging or updating a database.

### TimelineManager::Timeline.data

Returns the unmodified data.

### TimelineManager::Timeline.insert(event[, time_diff, start_method, end_method, post_delete, post_create, post_update])

Returns a new `Timeline` object.

Parameters are the same as `Timeline`, but can be set specifically for this event.

### TimelineManager::Timeline.overlap(event[, time_diff, start_method, end_method, post_delete, post_create, post_update])

Returns a new `Timeline` object.

Parameters are the same as `Timeline`, but can be set specifically for this event.

### TimelineManager::Timeline.overlay(event[, time_diff, start_method, end_method, post_create])

Returns a new `Timeline` object.

Parameters are the same as `Timeline`, but can be set specifically for this event.

### TimelineManager::Timeline.split(event[, time_diff, post_update])

Returns a new `Timeline` object.

Parameters are the same as `Timeline`, but can be set specifically for this event.

## Installation

Simply download the gem `timeline-manager` (perhaps with bundler -- `bundler install timeline-manager`), `require timeline-manager` and then instantiate: `timeline = TimelineManager::Timeline.new`
