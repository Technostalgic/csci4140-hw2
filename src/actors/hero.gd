class_name Hero
extends CharacterBody2D

signal die()

@export var death_sound: AudioStream = null
@export var camera: Camera2D = null
@export var hurtbox: Area2D = null
@export var health_bar: ProgressBar = null
@export var gun: Gun = null
@export var happy_boo: Node2D = null
@export var movement_speed: float = 600
@export var health: float = 100
@export var knockback_decay: float = 5000

var knockback_velocity = Vector2.ZERO
var kills: int = 0

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
	velocity = movement * movement_speed + knockback_velocity
	move_and_slide()
	
	
	# knockback velocity friction
	if knockback_velocity.length_squared() > 1:
		knockback_velocity -= knockback_velocity.normalized() * knockback_decay * delta
		if knockback_velocity.length_squared() <= 1:
			knockback_velocity = Vector2.ZERO
	
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

func knockback(force: Vector2) -> void:
	knockback_velocity += force

func kill() -> void:
	
	# emit death signal on die and remove hero
	die.emit()
	queue_free()
	
	# play hero death sound
	var audio := AudioStreamPlayer.new()
	audio.stream = death_sound
	audio.finished.connect(audio.queue_free) # remove audio node when sound effect is done playing
	get_tree().root.add_child(audio)
	audio.play()
