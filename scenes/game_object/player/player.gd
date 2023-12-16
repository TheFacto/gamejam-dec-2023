extends CharacterBody2D

@onready var velocity_component = $VelocityComponent

@onready var base_speed = 0

func _process(delta):
	base_speed = velocity_component.max_speed
	
	var movement_vector = get_movement_vector()
	var direction = movement_vector.normalized()
	velocity_component.accelerate_in_direction(direction)
	velocity_component.move(self)
	
	#if movement_vector.x != 0 || movement_vector.y != 0:
		#animation_player.play("walk")
	#else:
		#animation_player.play("RESET")
		#
	#var move_sign = sign(movement_vector.x)
	#if move_sign != 0:
		#visuals.scale = Vector2(move_sign, 1)

func get_movement_vector() -> Vector2:	
	var x_movement = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var y_movement = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	return Vector2(x_movement, y_movement)
