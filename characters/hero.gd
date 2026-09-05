extends CharacterBody2D

@export var movement_speed: float = 600

const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	
	var movement = Input.get_vector(
		"move_left", 
		"move_right", 
		"move_up", 
		"move_down"
	)
	
	velocity = movement * movement_speed
	
	move_and_slide()
