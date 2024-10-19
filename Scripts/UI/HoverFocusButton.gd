class_name HoverFocusButton extends BaseButton

func _notification(_message:int) -> void:
	if not self.has_focus() and is_hovered():
		self.grab_focus()
	
