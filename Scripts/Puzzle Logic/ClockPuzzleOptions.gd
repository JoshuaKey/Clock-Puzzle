class_name ClockPuzzleOptions extends RefCounted
## Options for randomly generating a Clock Puzzle

## How many "Hours" the Clock has on it.
var clock_size:int = 6

## The value an "Hour" can have
var hour_minimum:int = 1
var hour_maximum:int = 6

## The seed of the Random Number Generator
var puzzle_seed:int = 0

# TODO: Distribution of Hours ???

## Ensure the data for Puzzle Creation is valid
func validate() -> void:
	# Clock Size must have at least 4 "hours"
	if clock_size < 4:
		clock_size = 4
	
	# Maximum Hour Value must be less than Clock Size
	if hour_maximum >= clock_size:
		hour_maximum = clock_size - 1
	
	# Minimum Hour Value must be at least 1
	if hour_minimum < 1:
		hour_minimum = 1
