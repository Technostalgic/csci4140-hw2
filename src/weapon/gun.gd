class_name Gun
extends Node2D

@export var projectile_spawnpoint: Marker2D = null
@export var fire_timer: Timer = null
@export var active: bool = true
@export var fire_rate: float = 0.3

var ready_to_fire: bool = false

func _ready() -> void:
	fire_timer.timeout.connect(_fire_timer_timeout)
	
func _process(delta: float) -> void:
	if not active: return
	
	# handle whether or not the gun should be firing
	if Input.is_action_pressed("Shoot"):
		if ready_to_fire:
			fire()
			ready_to_fire = false
		if fire_timer.is_stopped():
			fire_timer.start(fire_rate)
	
	aim_toward(get_global_mouse_position(), delta)

func _fire_timer_timeout(): 
	fire_timer.stop()
	ready_to_fire = true

func aim_toward(target_position: Vector2, _delta: float):
	
	var difference: Vector2 = target_position - global_position
	var direction := atan2(difference.y, difference.x)
	global_rotation = direction
	
	if direction > PI * 0.5 or direction < -PI * 0.5:
		scale.y = -1
	else:
		scale.y = 1

func fire():
	pass
