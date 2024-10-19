extends Node

const USER_DATA_PATH:String = "user://user_data.tres"

const TUTORIAL_PUZZLE_HOURS:Array[int] = [3, 2, 2, 1]

var user_data:UserData = null

var _puzzle_options:ClockPuzzleOptions = ClockPuzzleOptions.new()
var _puzzle:ClockPuzzle = null

func _ready() -> void:
	# Load or Create User Data
	var data:UserData = SaveSystem.load_resource(USER_DATA_PATH) as UserData
	if data:
		user_data = data
	else:
		user_data = UserData.new()
		SaveSystem.save_resource(USER_DATA_PATH, user_data)

func start_playing() -> void:
	assert(user_data, "ERROR: User Data not loaded")
	if not user_data:
		return
	
	# Check for Tutorial Completion
	if not user_data.has_completed_tutorial:
		# Create and play Tutorial puzzle
		_puzzle = ClockPuzzle.create_puzzle(TUTORIAL_PUZZLE_HOURS)
		play_puzzle()
		return
	
	#SceneManager.change_scene(play_scene)
	
	pass

func play_new_puzzle() -> void:
	# Generate new Puzzle
	_puzzle = ClockPuzzle.generate_puzzle(_puzzle_options)
	
	# Play Puzzle
	play_puzzle()

func play_puzzle() -> void:
	assert(_puzzle, "ERROR: Puzzle is not created")
	if not _puzzle:
		return
	
	#SceneManager.change_scene(play_scene)

func reset_puzzle() -> void:
	pass

func set_puzzle_difficulty(puzzle_difficulty:int) -> void:
	match puzzle_difficulty:
		0: # Learning Difficulty
			pass
		1: # Easy Difficulty
			pass
		2: # Medium Difficulty
			pass
		3: # Hard Difficulty
			pass
		4: # Ultimate Difficulty
			pass
		5: # 13th Hour Difficulty
			pass
		_:
			pass
	pass

func set_puzzle_type(puzzle_type:int) -> void:
	pass

func set_puzzle_mode(puzzle_mode:int) -> void:
	pass

func quit_game() -> void:
	# Save User Data
	SaveSystem.save_resource(USER_DATA_PATH, user_data)
	
	# Quit
	get_tree().quit()
