class_name Gib
extends Node2D

signal life_expired(gib: Gib)

@export var graphic: Node2D = null
@export var shadow: Node2D = null
@export var radius: float = 10
@export var acceleration: Vector3 = Vector3.FORWARD * 1500
@export var bounciness: float = 0.5
@export var friction: float = 0.9
@export var ground_life: float = 0.25

var life: float = 0
var velocity: Vector3 = Vector3.ZERO
var rotational_vel: float = 0
var air_height: float = 0
var parent_fx: GibEffects = null

func _enter_tree() -> void:
	show()
	life = 0
	modulate.a = 1
	rotational_vel = (randf() - 0.5) * 20 * PI

func _physics_process(delta: float) -> void:
	
	# velocity and position integration
	velocity += acceleration * delta
	position += Vector2(velocity.x, velocity.y) * delta
	air_height += velocity.z * delta
	graphic.position.y = -air_height
	
	# bounce on the ground
	if air_height <= radius:
		air_height = radius
		graphic.position.y = -radius
		velocity.z = absf(velocity.z) * bounciness
		velocity.x *= friction
		velocity.y *= friction
		rotational_vel *= friction
		if velocity.z > 10:
			Game.instance.blood_puddles.spawn_effect(global_position, 0)
	
	shadow.position.y = air_height

func _process(delta: float) -> void:
	graphic.rotation += rotational_vel * delta
	
	if Vector2(velocity.x, velocity.y).length_squared() <= 1:
		life += delta
		if life >= ground_life:
			life = ground_life
			life_expired.emit(self)
			hide()
	
	var life_delta := life / ground_life
	modulate.a = 1 - life_delta
