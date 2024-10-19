class_name PuzzleSelect extends Control

@onready var difficulty_select: DifficultySelect = $"Difficulty Select"
@onready var puzzle_type_select: PuzzleTypeSelect = $"Puzzle Type Select"
@onready var puzzle_mode_select: PuzzleModeSelect = $"Puzzle Mode Select"

var screen_type:Constants.PuzzleSelection = Constants.PuzzleSelection.PUZZLE_DIFFICULTY

const PUZZLE_SCENE:String = ""
const MAIN_MENU_SCENE:String = ""

func _ready() -> void:
	difficulty_select.on_difficulty_selected.connect(_on_difficulty_selected)
	puzzle_type_select.on_puzzle_type_selected.connect(_on_puzzle_type_selected)
	puzzle_mode_select.on_puzzle_mode_selected.connect(_on_puzzle_mode_selected)
	
	difficulty_select.visible = screen_type == Constants.PuzzleSelection.PUZZLE_DIFFICULTY
	puzzle_type_select.visible = screen_type == Constants.PuzzleSelection.PUZZLE_TYPE
	puzzle_mode_select.visible = screen_type == Constants.PuzzleSelection.PUZZLE_MODE
	
	pass

func _on_back_button_pressed() -> void:
	#var _prev_screen_type:Constants.PuzzleSelection = screen_type - 1
	
	if false:
		pass
	else:
		SceneManager.change_scene(MAIN_MENU_SCENE)
	pass

func _on_difficulty_selected() -> void:
	pass

func _on_puzzle_type_selected() -> void:
	pass

func _on_puzzle_mode_selected() -> void:
	pass

