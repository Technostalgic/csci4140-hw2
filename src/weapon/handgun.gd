class_name Handgun
extends Gun

var ready_to_fire: bool = false
var fire_rate: float = 0.3
@export var projectile_spawnpoint: Marker2D = null
@export var fire_timer: Timer = null
@export var projectile: PackedScene = null
@export var muzzle_flash: PackedScene = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fire_timer.timeout.connect(_fire_timer_timeout)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not active: return
	
	# handle whether or not the gun should be firing
	if Input.is_action_pressed("Shoot"):
		if ready_to_fire:
			fire()
		if fire_timer.is_stopped():
			fire_timer.start(fire_rate)
	
	var difference: Vector2 = get_global_mouse_position() - global_position
	var direction := atan2(difference.y, difference.x)
	global_rotation = direction
	
	if direction > PI * 0.5 or direction < -PI * 0.5:
		scale.y = -1
	else:
		scale.y = 1

func _fire_timer_timeout(): 
	fire_timer.stop()
	ready_to_fire = true

func fire() -> void:
	ready_to_fire = false
	var flash: Node2D = muzzle_flash.instantiate()
	projectile_spawnpoint.add_child(flash)
	flash.position = Vector2.ZERO
	var bullet: Bullet = projectile.instantiate()
	get_tree().root.add_child(bullet)
	bullet.global_position = projectile_spawnpoint.global_position
	bullet.global_rotation = projectile_spawnpoint.global_rotation
