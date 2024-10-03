class_name HourScene extends Node2D

@onready var button: Button = $Button
@onready var selectable_highlight: ColorRect = $SelectableHighlight

var hour_value:int:
	set(value):
		hour_value = value
		if button:
			button.text = str(hour_value)
var button_callable:Callable:
	set(value):
		button_callable = value
		if button:
			button.pressed.connect(button_callable)
var is_selectable:bool:
	set = set_is_selectable
var is_active:bool:
	set(value):
		is_active = value
		if button:
			button.disabled = not is_active

func _ready() -> void:
	button.text = str(hour_value)
	button.disabled = is_active
	if button_callable:
		button.pressed.connect(button_callable)
	
	set_is_selectable(is_selectable)

func set_is_selectable(value:bool) -> void: 
	is_selectable = value 
	if not selectable_highlight:
		return
	
	# Adjust Color of Selectable Higlight
	var color:Color = selectable_highlight.color
	if is_selectable and is_active:
		color.a = 1
	else:
		color.a = 0
	selectable_highlight.color = color
