class_name Hero
extends CharacterBody2D

signal die()

@export var hurtbox: Area2D = null
@export var health_bar: ProgressBar = null
@export var happy_boo: Node2D = null
@export var movement_speed: float = 600
var health: float = 100

func _physics_process(delta: float) -> void:
	# do nothing if dead
	if health <= 0: return
	
	# handle input and movement
	var movement = Input.get_vector(
		"move_left", 
		"move_right", 
		"move_up", 
		"move_down"
	)
	velocity = movement * movement_speed
	move_and_slide()
	handle_animation()
	
	# handle damage from mobs
	var bodies = hurtbox.get_overlapping_bodies()
	for body in bodies:
		if body is Mob:
			health -= 5 * delta
	
	# emit death signal on die
	if health <= 0:
		die.emit()
	
	# display health in progress bar
	health_bar.value = health

func handle_animation():
	# walk animation if moving
	if velocity.length() > 1:
		happy_boo.play_walk_animation()
	
	# idle animation if not moving
	else: 
		happy_boo.play_idle_animation()
