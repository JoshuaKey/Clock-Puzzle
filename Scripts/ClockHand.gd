class_name ClockHand extends Node2D

signal reached_target

const EPSILON:float = .1

var _rotation_speed:float = 30
var _direction:int = 1
var _rotation_target:float = 99999999

var _pause_time:float = 0.0
var _has_reached_target:bool = false

func _ready() -> void:
	reached_target.connect(_on_target_reached)

func _physics_process(delta: float) -> void:
	# Pause Rotation for a time
	if _pause_time > 0:
		_pause_time -= delta
		return
	else:
		_pause_time = 0.0
	
	if _has_reached_target:
		# Already at Target, ignore...
		return
	
	var new_rotation:float = self.rotation_degrees + _rotation_speed * delta * _direction
	
	var old_distance:float = self.rotation_degrees - _rotation_target
	var new_distance:float = new_rotation - _rotation_target
	if old_distance * new_distance < EPSILON:
		# Distances have opposite signs, meaning they passed 0
		# We hit our target
		print(self.name + " at " + str(self.rotation_degrees) + " reached the Rotation Target of " + str(_rotation_target))
		
		self.rotation_degrees = _rotation_target
		_has_reached_target = true
		reached_target.emit()
	else:
		self.rotation_degrees = new_rotation
	pass

func clamp_rotation_degrees(degrees:float) -> float:
	# Clamp Rotation between 0 and 360
	var clamped_degrees:float  = int(degrees) % 360
	if clamped_degrees < 0.0:
		clamped_degrees += 360.0
	clamped_degrees += degrees - int(degrees)
	
	return clamped_degrees

func set_pause_time(time:float) -> void:
	_pause_time = time

func set_rotation_speed(speed:float) -> void:
	_rotation_speed = abs(speed)

func set_rotation_direction(direction:int) -> void:
	if direction > 0:
		_direction = 1
	elif direction < 0: 
		_direction = -1

## Updates the Rotation Target so the Clock Hand moves to the nearest Angle
func set_nearest_rotation_target(rotation_target:float) -> void:
	# Clamp our current Rotation Degrees before setting a Rotation Target
	self.rotation_degrees = clamp_rotation_degrees(self.rotation_degrees)
	
	print(self.name + " is rotating in direction " + str(_direction))
	print(self.name + " is currently at " + str(self.rotation_degrees) + " and is rotating towards " + str(rotation_target))
	
	# Clamp the Target Rotation from 0 to 360
	var target_degree:float = clamp_rotation_degrees(rotation_target)
	
	var difference_to:float = target_degree - self.rotation_degrees
	if difference_to < 0:
		difference_to += 360
	var difference_from:float = self.rotation_degrees - target_degree
	if difference_from < 0:
		difference_from += 360
	
	var difference:float = difference_to if difference_to < difference_from else difference_from
	var new_direction:int = 1 if difference_to < difference_from else -1
	if difference_to == difference_from:
		new_direction = _direction
	
	print("The differrence in degrees is " + str(difference))
	
	if difference < EPSILON and difference > -EPSILON:
		# Close Enough, we are at Target Rotation
		print(self.name + " was already at Target " + str(_rotation_target))
		
		_rotation_target = self.rotation_degrees
		_has_reached_target = true
		reached_target.emit()
		return
	
	# We need to keep rotating in our current direction till we reach the difference 
	_has_reached_target = false
	_direction = new_direction
	_rotation_target = int(self.rotation_degrees) + difference * new_direction
	
	print("New Target of " + str(_rotation_target))

## Updates the Rotation Target so the Clock Hand moves to the next Angle in it's current direction
func set_next_rotation_target(rotation_target:float) -> void:
	# Clamp our current Rotation Degrees before setting a Rotation Target
	self.rotation_degrees = clamp_rotation_degrees(self.rotation_degrees)
	
	print(self.name + " is rotating in direction " + str(_direction))
	print(self.name + " is currently at " + str(self.rotation_degrees) + " and is rotating towards " + str(rotation_target))
	
	# Clamp the Target Rotation from 0 to 360
	var target_degree:float = clamp_rotation_degrees(rotation_target)
	
	# Adjust our Target by 360 if we are already passed it
	if _direction == 1 and target_degree < self.rotation_degrees:
		target_degree += 360.0
	elif _direction == -1 and target_degree > self.rotation_degrees:
		target_degree -= 360.0
	
	# Find the difference in degrees
	var difference:float = target_degree - self.rotation_degrees
	
	print("The differrence in degrees is " + str(difference))
	
	if difference < EPSILON and difference > -EPSILON:
		# Close Enough, we are at Target Rotation
		print(self.name + " was already at Target " + str(_rotation_target))
		
		_rotation_target = self.rotation_degrees
		_has_reached_target = true
		reached_target.emit()
		return
	
	# Set new Rotation Target
	_has_reached_target = false
	_rotation_target = target_degree
	
	print("New Target of " + str(_rotation_target))

func set_rotation_target(value:float) -> void:
	# Clamp our current Rotation Degrees before setting a Rotation Target
	self.rotation_degrees = clamp_rotation_degrees(self.rotation_degrees)
	
	_has_reached_target = false
	_rotation_target = value

func get_rotation_target() -> float:
	return _rotation_target

### EVENTS ###
func _on_target_reached() -> void:
	# Clamp our rota3tion degrees after reaching our target
	self.rotation_degrees = clamp_rotation_degrees(self.rotation_degrees)
	
