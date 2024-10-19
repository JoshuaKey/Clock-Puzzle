class_name ClockPuzzleScene extends Node2D

signal player_won
signal player_failed

## At 0 degrees, Clock Hands face UP.
## [br]At 0 degrees, a Circle is facing Right
## [br]The Offset is the difference so Clock Hands have the correct
## Rotational Targets.
const CLOCK_HAND_ROTATION_OFFSET:int = 90
const HOUR_DISTANCE:int = 190

@export_group("Nodes")
@export var clock_hand_1:ClockHand
@export var clock_hand_2:ClockHand
@export var hour_nodes:Array[HourScene]

@export_group("Random Clock Hand Animation")
## Degrees / Second
@export var clock_hand_1_random_rotation_speed:int = 420
## Degrees / Second
@export var clock_hand_2_random_rotation_speed:int = -300

@export_group("Clock Hand Animation")
## Degrees / Second
@export var clock_hand_rotation_speed:int = 540
## Seconds to pause after Clock Hand reaches destination
@export var clock_hand_pause_time:float = 0.5

@export_group("Win Animation")
@export var clock_hand_tick_degree:int = 10
@export var clock_hand_tick_time:float = 0.5

@export_group("Lose Animation")
@export var clock_hand_maximum_speed:int = 999
@export var clock_hand_time_to_max_speed:float = 60

var puzzle:ClockPuzzle

var _clock_hand_reached_target_count:int = 0

func _ready() -> void:
	# Signals
	clock_hand_1.reached_target.connect(_on_clock_hand_target_reached)
	clock_hand_2.reached_target.connect(_on_clock_hand_target_reached)
	
	player_won.connect(print_message.bind("You won!"))
	player_won.connect(_on_player_won)
	player_failed.connect(print_message.bind("You failed!"))
	player_failed.connect(_on_player_failed)
	
	# Puzzle Creation
	#var options:ClockPuzzleOptions = ClockPuzzleOptions.new()
	#options.clock_size = 8
	#options.hour_minimum = 1
	#options.hour_maximum = options.clock_size - 1
	#options.puzzle_seed = 5
	#puzzle = ClockPuzzle.generate_puzzle(options)
	
	var clock_array:Array[int] = [1, 1, 2, 2]
	puzzle = ClockPuzzle.create_puzzle(clock_array)
	
	var solver:ClockPuzzle.ClockPuzzleSolver = ClockPuzzle.ClockPuzzleSolver.new()
	var is_puzzle_solvable:bool = solver.check_is_solvable(puzzle)
	print("This puzzle is Solvable: " + str(is_puzzle_solvable))
	
	create_puzzle()

func reset_puzzle() -> void:
	puzzle.reset()
	
	create_puzzle()

func clear_puzzle() -> void: 
	for child:Node in hour_nodes:
		self.remove_child(child)
		child.queue_free()
	hour_nodes.clear()

func create_puzzle() -> void:
	clear_puzzle()
	
	var hour_template_scene:PackedScene = preload("res://scenes/hour.tscn")
	
	var clock_size:int = puzzle.get_clock_size()
	var selectable_hours:Array[int] = puzzle.get_selectable_hours()
	for i:int in clock_size:
		var hour:ClockPuzzle.Hour = puzzle.get_hour(i)
		
		var hour_rotation_degress:float = (float(i) / clock_size) * 360 
		var hour_rotation_radians:float = hour_rotation_degress * (PI / 180)
		 
		var hour_scene:HourScene = hour_template_scene.instantiate()
		self.add_child(hour_scene) # Hour Scene is added to Tree and _ready() is called
		
		hour_scene.hour_value = hour.get_value()
		hour_scene.clock_index = i
		hour_scene.clock_rotation = hour_rotation_degress
		hour_scene.position.x = cos(hour_rotation_radians) * HOUR_DISTANCE
		hour_scene.position.y = sin(hour_rotation_radians) * HOUR_DISTANCE
		
		hour_scene.button_callable = _on_hour_pressed.bind(hour_scene)
		
		hour_scene.is_active = hour.is_active()
		hour_scene.is_selectable = i in selectable_hours
		hour_nodes.append(hour_scene)
	
	clock_hand_1.set_rotation_speed(clock_hand_1_random_rotation_speed)
	clock_hand_1.set_rotation_direction(1)
	clock_hand_2.set_rotation_speed(clock_hand_2_random_rotation_speed)
	clock_hand_2.set_rotation_direction(-1)

func update_puzzle() -> void:
	var selectable_hours:Array[int] = puzzle.get_selectable_hours()
	
	if selectable_hours.size() == 2:
		# Update Clock Hand Rotation Speed
		clock_hand_1.set_rotation_speed(clock_hand_rotation_speed)
		clock_hand_1.set_rotation_direction(1)
		clock_hand_2.set_rotation_speed(clock_hand_rotation_speed)
		clock_hand_2.set_rotation_direction(-1)
		
		# Rotate to the hours the player can choose
		var index_1:int = selectable_hours[0]
		var hour_1_rotation:float = (float(index_1) / puzzle.get_clock_size()) * 360 
		clock_hand_1.set_nearest_rotation_target(hour_1_rotation + CLOCK_HAND_ROTATION_OFFSET)
		
		var index_2:int = selectable_hours[1]
		var hour_2_rotation:float = (float(index_2) / puzzle.get_clock_size()) * 360 
		clock_hand_2.set_nearest_rotation_target(hour_2_rotation + CLOCK_HAND_ROTATION_OFFSET)
		pass
	
	# Update Node selectable and active state
	for i:int in hour_nodes.size():
		var hour_node:HourScene = hour_nodes[i]
		var hour:ClockPuzzle.Hour = puzzle.get_hour(i)
		hour_node.is_active = hour.is_active()
		hour_node.is_selectable = i in selectable_hours
	
	# Check for Win / Loss condition
	if puzzle.is_puzzle_completed():
		player_won.emit()
	elif puzzle.is_puzzle_failed():
		player_failed.emit()

func _on_hour_pressed(hour:HourScene) -> void:
	print("Pressed " + str(hour))
	var is_first_move:bool = puzzle.get_selectable_hours().size() > 2
	if not puzzle.choose_hour(hour.clock_index):
		return
	
	_clock_hand_reached_target_count = 0
	
	clock_hand_1.set_rotation_speed(clock_hand_rotation_speed)
	clock_hand_2.set_rotation_speed(clock_hand_rotation_speed)
	
	if is_first_move:
		clock_hand_1.set_next_rotation_target(hour.clock_rotation + CLOCK_HAND_ROTATION_OFFSET)
		clock_hand_2.set_next_rotation_target(hour.clock_rotation + CLOCK_HAND_ROTATION_OFFSET)
	else:
		clock_hand_1.set_rotation_direction(1)
		clock_hand_1.set_nearest_rotation_target(hour.clock_rotation + CLOCK_HAND_ROTATION_OFFSET)
		clock_hand_2.set_rotation_direction(-1)
		clock_hand_2.set_nearest_rotation_target(hour.clock_rotation + CLOCK_HAND_ROTATION_OFFSET)
	pass

func _on_clock_hand_target_reached() -> void:
	_clock_hand_reached_target_count += 1
	
	# Both Clock Hands have reached target
	# Continue Game...
	if _clock_hand_reached_target_count == 2:
		clock_hand_1.set_pause_time(clock_hand_pause_time)
		clock_hand_2.set_pause_time(clock_hand_pause_time)
		update_puzzle()

func print_message(message:String) -> void:
	print(message)

### FAIL ANIMATION ###
func _on_player_failed() -> void:
	clock_hand_1.reached_target.disconnect(_on_clock_hand_target_reached)
	clock_hand_2.reached_target.disconnect(_on_clock_hand_target_reached)
	
	clock_hand_1.reached_target.connect(_on_start_broken_clock)
	clock_hand_2.reached_target.connect(_on_start_broken_clock)
	
	clock_hand_1.set_rotation_direction(1)
	clock_hand_1.set_nearest_rotation_target(0)
	
	clock_hand_2.set_rotation_direction(-1)
	clock_hand_2.set_nearest_rotation_target(0)
	
	_clock_hand_reached_target_count = 0

func _on_start_broken_clock() -> void:
	_clock_hand_reached_target_count += 1
	if _clock_hand_reached_target_count != 2:
		return
	
	clock_hand_1.reached_target.disconnect(_on_start_broken_clock)
	clock_hand_2.reached_target.disconnect(_on_start_broken_clock)
	
	clock_hand_1.set_rotation_direction(1)
	clock_hand_1.set_rotation_speed(0)
	clock_hand_1.set_rotation_target(30000 + randf() * 360)
	var tween1:Tween = clock_hand_1.create_tween()
	tween1.tween_property(clock_hand_1, "_rotation_speed", clock_hand_maximum_speed, clock_hand_time_to_max_speed)
	
	clock_hand_2.set_rotation_direction(-1)
	clock_hand_2.set_rotation_speed(0)
	clock_hand_2.set_rotation_target(-30000 + randf() * 360)
	var tween2:Tween = clock_hand_2.create_tween()
	tween2.tween_property(clock_hand_2, "_rotation_speed", clock_hand_maximum_speed, clock_hand_time_to_max_speed)

### WIN ANIMATION ###
func _on_player_won() -> void:
	clock_hand_1.reached_target.disconnect(_on_clock_hand_target_reached)
	clock_hand_2.reached_target.disconnect(_on_clock_hand_target_reached)
	
	clock_hand_1.reached_target.connect(_on_start_victory_clock)
	clock_hand_2.reached_target.connect(_on_start_victory_clock)
	
	clock_hand_1.set_rotation_direction(1)
	clock_hand_1.set_nearest_rotation_target(0)
	
	clock_hand_2.set_rotation_direction(-1)
	clock_hand_2.set_nearest_rotation_target(0)
	
	_clock_hand_reached_target_count = 0
	pass

func _on_start_victory_clock() -> void:
	_clock_hand_reached_target_count += 1
	if _clock_hand_reached_target_count != 2:
		return
	
	clock_hand_1.reached_target.disconnect(_on_start_victory_clock)
	clock_hand_2.reached_target.disconnect(_on_start_victory_clock)
	
	clock_hand_1.reached_target.connect(_on_continue_victory_clock)
	
	clock_hand_1.set_pause_time(clock_hand_tick_time)
	clock_hand_1.set_rotation_direction(1)
	clock_hand_1.set_rotation_speed(360)
	clock_hand_1.set_next_rotation_target(clock_hand_tick_degree)
	
	clock_hand_2.set_pause_time(9999)
	clock_hand_2.set_rotation_direction(1)
	clock_hand_2.set_rotation_speed(360)

func _on_continue_victory_clock() -> void:
	var current_degree:float = clock_hand_1.get_rotation_target()
	clock_hand_1.set_pause_time(clock_hand_tick_time)
	clock_hand_1.set_next_rotation_target(current_degree + clock_hand_tick_degree)
	
	if current_degree >= 360:
		clock_hand_2.set_pause_time(clock_hand_tick_time)
		clock_hand_2.set_next_rotation_target(clock_hand_2.get_rotation_target() + clock_hand_tick_degree)
