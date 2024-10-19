class_name DifficultySelect extends Control

signal on_difficulty_selected

@onready var learning_button: Button = $VBoxContainer/LearningButton
@onready var easy_button: Button = $VBoxContainer/EasyButton
@onready var medium_button: Button = $VBoxContainer/MediumButton
@onready var hard_button: Button = $VBoxContainer/HardButton
@onready var ultimate_button: Button = $VBoxContainer/UltimateButton
@onready var _13_th_hour_button: Button = $"VBoxContainer/13thHourButton"


func _ready() -> void:
	learning_button.visible = false
	easy_button.visible = false
	medium_button.visible = false
	hard_button.visible = false
	ultimate_button.visible = false
	_13_th_hour_button.visible = false
	pass


func _on_learning_button_pressed() -> void:
	pass # Replace with function body.


func _on_easy_button_pressed() -> void:
	pass # Replace with function body.


func _on_medium_button_pressed() -> void:
	pass # Replace with function body.


func _on_hard_button_pressed() -> void:
	pass # Replace with function body.


func _on_ultimate_button_pressed() -> void:
	pass # Replace with function body.


func _on_13_hour_button_pressed() -> void:
	pass # Replace with function body.
