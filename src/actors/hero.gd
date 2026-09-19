class_name Hero
extends CharacterBody2D

signal die()

@export var camera: Camera2D = null
@export var hurtbox: Area2D = null
@export var health_bar: ProgressBar = null
@export var gun: Gun = null
@export var happy_boo: Node2D = null
@export var movement_speed: float = 600
@export var health: float = 100

var kills: int = 0
var idle_firerate: float = 0.05
var moving_firerate: float = 0.2

func _physics_process(delta: float) -> void:
	# do nothing if dead
	if health <= 0: 
		gun.active = false
		return
	
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
	
	# handle firerate changing
	if velocity.length_squared() > 1:
		gun.fire_rate = moving_firerate
	else: 
		gun.fire_rate = idle_firerate
	
	# handle damage from mobs
	var bodies = hurtbox.get_overlapping_bodies()
	for body in bodies:
		if body is Mob:
			health -= 5 * delta
	
	if health <= 0:
		kill()
	
	# display health in progress bar
	health_bar.value = health

func _process(delta: float) -> void:
	_handle_camera_follow(delta)

func _handle_camera_follow(_delta: float) -> void:
	if not camera: return
	camera.global_position = global_position

func kill() -> void:
	
	# emit death signal on die and remove hero
	die.emit()
	queue_free()

func handle_animation():
	# walk animation if moving
	if velocity.length() > 1:
		happy_boo.play_walk_animation()
	
	# idle animation if not moving
	else: 
		happy_boo.play_idle_animation()
