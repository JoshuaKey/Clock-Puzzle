class_name PuzzleTypeSelect extends Control

signal on_puzzle_type_selected

@onready var normal_button: Button = $VBoxContainer/NormalButton
@onready var double_button: Button = $VBoxContainer/DoubleButton
@onready var recursive_button: Button = $VBoxContainer/RecursiveButton
@onready var double_recursive_button: Button = $VBoxContainer/DoubleRecursiveButton

func _ready() -> void:
	normal_button.visible = true
	double_button.visible = false
	recursive_button.visible = false
	double_recursive_button.visible = false
	pass 

func show_screen() -> void:
	pass

func _on_normal_button_pressed() -> void:
	pass # Replace with function body.


func _on_double_button_pressed() -> void:
	pass # Replace with function body.


func _on_recursive_button_pressed() -> void:
	pass # Replace with function body.


func _on_double_recursive_button_pressed() -> void:
	pass # Replace with function body.
