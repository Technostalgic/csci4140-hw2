class_name Hero
extends CharacterBody2D

@export var happy_boo: Node2D = null
@export var movement_speed: float = 600

func _physics_process(delta: float) -> void:
	var movement = Input.get_vector(
		"move_left", 
		"move_right", 
		"move_up", 
		"move_down"
	)
	velocity = movement * movement_speed
	handle_animation()
	move_and_slide()

func handle_animation():
	if velocity.length() > 1:
		happy_boo.play_walk_animation()
	else: 
		happy_boo.play_idle_animation()
