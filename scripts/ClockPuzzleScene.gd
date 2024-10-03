class_name ClockPuzzleScene extends Node2D

signal player_won
signal player_failed

const HOUR_DISTANCE:int = 200

@export
var hour_nodes:Array[HourScene]

var puzzle:ClockPuzzle

func _ready() -> void:
	#var hours:Array[int] = []
	#hours.append(1)
	#hours.append(1)
	#hours.append(1)
	#hours.append(1)
	#hours.append(1)
	#hours.append(1)
	#hours.append(1)
	#hours.append(1)
	#puzzle = ClockPuzzle.create_puzzle(hours)
	
	var options:ClockPuzzleOptions = ClockPuzzleOptions.new()
	options.clock_size = 6
	options.hour_minimum = 1
	options.hour_maximum = options.clock_size / 2
	puzzle = ClockPuzzle.generate_puzzle(options)
	
	create_puzzle()
	player_won.connect(print_message.bind("You won!"))
	player_failed.connect(print_message.bind("You failed!"))

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
	for i:int in clock_size:
		var hour:ClockPuzzle.Hour = puzzle.get_hour(i)
		
		var hour_rotation:float = (float(i) / clock_size) * 360 * (PI / 180)
		 
		var hour_scene:HourScene = hour_template_scene.instantiate()
		
		hour_scene.position.x = cos(hour_rotation) * HOUR_DISTANCE
		hour_scene.position.y = sin(hour_rotation) * HOUR_DISTANCE
		hour_scene.hour_value = hour.get_value()
		hour_scene.button_callable = _on_hour_pressed.bind(i)
		
		self.add_child(hour_scene)
		hour_nodes.append(hour_scene)
	update_puzzle()

func update_puzzle() -> void:
	var selectable_hours:Array[int] = puzzle.get_selectable_hours()
	for i:int in hour_nodes.size():
		var hour_node:HourScene = hour_nodes[i]
		var hour:ClockPuzzle.Hour = puzzle.get_hour(i)
		hour_node.is_active = hour.is_active()
		hour_node.is_selectable = i in selectable_hours
	
	if puzzle.is_puzzle_completed():
		player_won.emit()
	elif puzzle.is_puzzle_failed():
		player_failed.emit()

func _on_hour_pressed(hour_index:int) -> void:
	puzzle.choose_hour(hour_index)
	update_puzzle()
	pass

func print_message(message:String) -> void:
	print(message)
