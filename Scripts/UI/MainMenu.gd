extends Control

var play_scene:String = "res://Scenes/puzzle_select.tscn"
var settings_scene:String = ""

func _on_play_button_pressed() -> void:
	GameManager.start_playing()

func _on_settings_button_pressed() -> void:
	#get_tree()
	pass

func _on_exit_button_pressed() -> void:
	GameManager.quit_game()
