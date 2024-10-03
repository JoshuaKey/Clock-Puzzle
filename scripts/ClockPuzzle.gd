class_name ClockPuzzle extends RefCounted
## Clock Puzzle 

#region Variables
var _clock: Array[Hour] = []
var _first_hour_index:int = -1
var _second_hour_index:int = -1
#endregion

## Generates a Clock Puzzle using the passed in Options.
##
## [br][br]Randomly generates a Clock Puzzle using the Clock Puzzle Options
## [br]clock_size: How many "Hours" the Clock Puzzle will have. Minimum of 4.
## [br]hour_minimum: The minimum value an Hour can have. Minimum of 1.
## [br]hour_maximum: The maximum value an Hour can have. Maximum of clock_size.
static func generate_puzzle(options:ClockPuzzleOptions) -> ClockPuzzle:
	# Create Random Number Generator
	var rand:RandomNumberGenerator = RandomNumberGenerator.new()
	rand.seed = 5
	rand.randomize()
	
	# Ensure valid Options
	options.validate()
	
	# Generate Clock Puzzle
	var puzzle:ClockPuzzle = ClockPuzzle.new()
	for i:int in options.clock_size:
		var value:int = rand.randi_range(options.hour_minimum, options.hour_maximum)
		var hour:Hour = Hour.new(value)
		puzzle._clock.append(hour)
	
	return puzzle

## Creates a Clock Puzzle using the passed in Array.
##
## [br][br]The size of the Array defines the size of the Clock Puzzle.
## [br]Each value in the Integer array is converted into an Hour.
static func create_puzzle(clock:Array[int]) -> ClockPuzzle:
	var puzzle:ClockPuzzle = ClockPuzzle.new()
	for value:int in clock:
		var hour:Hour = Hour.new(value)
		puzzle._clock.append(hour)
		
	return puzzle

## Resets the Clock Puzzle
func reset() -> void:
	_first_hour_index = -1
	_second_hour_index = -1
	for hour:Hour in _clock:
		hour.reset()

## Determines if the puzzle is Completed
##
## [br][br]Checks to see if any Hour on the Clock Puzzle is still active.
## [br]The player wins when each Hour has been deactivated.
func is_puzzle_completed() -> bool:
	# Check if an "Hour" is still active
	for i:int in range(_clock.size()):
		if _clock[i].is_active():
			return false
	
	return true

## Determines if the player has failed the Puzzle
##
## [br][br]Checks to see if the Hours a player can choose are not active.
## [br]If both hours are no longer active and there are other Hours still active
## then the player can no longer make a move and they have failed.
func is_puzzle_failed() -> bool:
	# Check if the 2 Selectable "Hours" are still active
	return not _first_hour_index == -1 and \
			not _clock[_first_hour_index].is_active() and \
			not _clock[_second_hour_index].is_active() and \
			not is_puzzle_completed()

## Chooses an Hour to progress the Puzzle
##
## [br][br]index: The index corresponding with the chosen Hour.
## [br]Deactivates the corresponding Hour. From that hour, the player is allowed to choose 
## 2 different hours at equal distance from the choosen hour based on the Hour's value.
## For example, if the choosen hour has a value of 1, then the player may choose an hour
## 1 to the left of the previous hour or 1 to the right of the previous hour.
func choose_hour(index:int) -> bool:
	# Player must choose valid Hour
	if index < 0 or index >= _clock.size():
		return false
	
	# Player must choose active Hour
	if not _clock[index].is_active():
		return false
	
	# Player has not made their first move. 
	# Player may choose any Hour.
	if _first_hour_index == -1:
		_choose_hour(index)
	
	# Player has made their first move.
	# Player must choose First or Second Hour
	else:
		if index != _first_hour_index and index != _second_hour_index:
			return false
		else:
			_choose_hour(index)
	return true

func _choose_hour(index:int) -> void:
	var hour:Hour = _clock[index]
	hour._active = false 
	_first_hour_index = index - hour.get_value()
	_second_hour_index = index + hour.get_value()
	
	# Wrap the First and Second Hour around...
	if _first_hour_index < 0:
		_first_hour_index = _clock.size() + _first_hour_index
	
	if _second_hour_index >= _clock.size():
		_second_hour_index = _second_hour_index - _clock.size()

## Returns the size of the Clock Puzzle. The number of "Hours" in it
func get_clock_size() -> int:
	return _clock.size()

## Returns the hour corresponding to the index
## [br]Returns null if index is invalid
func get_hour(index:int) -> Hour:
	if index < 0 or index >= _clock.size():
		return null
	return _clock[index]

## Returns an array of all the possible Hours the Player can select
## in the form of their Indices
func get_selectable_hours() -> Array[int]:
	if _first_hour_index == -1:
		var range_array:Array[int] = []
		range_array.append_array(range(_clock.size()))
		return range_array
	else:
		return [_first_hour_index, _second_hour_index]

## An "Hour" on the Clock Puzzle
class Hour:
	var _value:int = 2
	var _active:bool = true
	
	func _init(value:int) -> void:
		self._value = value
		self._active = true
	
	func reset() -> void:
		_active = true
		
	func get_value() -> int:
		return self._value
	
	func is_active() -> bool:
		return self._active
