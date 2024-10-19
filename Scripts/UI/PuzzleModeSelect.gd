class_name PuzzleModeSelect extends Control

signal on_puzzle_mode_selected

@onready var rotating_button: Button = $VBoxContainer/RotatingButton
@onready var time_button: Button = $VBoxContainer/TimeButton

func _ready() -> void:
	rotating_button.visible = false
	time_button.visible = false
	

func show_screen() -> void:
	pass

func _on_rotating_button_pressed() -> void:
	pass # Replace with function body.


func _on_time_button_pressed() -> void:
	pass # Replace with function body.
