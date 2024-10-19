class_name HourScene extends Node2D

@onready var selectable_highlight: Node2D = $SelectableHighlight
@onready var button: Button = $Button

var hour_value:int:
	set = set_hour_value
var button_callable:Callable:
	set = set_button_callable
var is_selectable:bool:
	set = set_is_selectable
var is_active:bool:
	set = set_is_active

var clock_rotation:float
var clock_index:int

func _ready() -> void:
	button.focus_entered.connect(_on_focuse_entered)
	button.focus_exited.connect(_on_focuse_exited)

func set_button_callable(value:Callable) -> void:
	if value != button_callable and button_callable:
		button.pressed.disconnect(button_callable)
	
	button_callable = value
	
	if button_callable:
		button.pressed.connect(button_callable)

func set_hour_value(value:int) -> void:
	hour_value = value
	button.text = str(hour_value)
	
	var hour_color:Color = Color.from_hsv(hour_value / 13.0, 1.0, 0.5)
	button.add_theme_color_override("font_color", hour_color)
	button.add_theme_color_override("font_pressed_color", hour_color)
	button.add_theme_color_override("font_hover_color", hour_color)
	button.add_theme_color_override("font_focus_color", hour_color)
	button.add_theme_color_override("font_hover_pressed_color", hour_color)
	button.add_theme_color_override("font_disabled_color", hour_color)

func set_is_active(value:bool) -> void:
	is_active = value
	self.visible = is_active

func set_is_selectable(value:bool) -> void: 
	is_selectable = value 
	selectable_highlight.visible = is_selectable and is_active

func _on_focuse_entered() -> void:
	selectable_highlight.self_modulate = Color(1, 1, 1, .5)

func _on_focuse_exited() -> void:
	selectable_highlight.self_modulate = Color(1, 1, 1, 1)
