class_name GibEffects
extends EffectSpawner

func _ready() -> void:
	assert(effect_base is Gib)
	super._ready()

func _get_pooled_item() -> Gib:
	var gib := super._get_pooled_item() as Gib
	return gib

func _on_gib_expire(gib: Gib) -> void:
	_pool_object(gib)

func spawn_gib(point: Vector2, height: float, vel: Vector2, up_vel: float) -> Gib:
	var gib := spawn_effect(point, 0) as Gib
	var rot = gib.global_rotation
	gib.global_rotation = 0
	gib.graphic.global_rotation = rot
	gib.global_position = Vector2(point.x, point.y + height)
	gib.air_height = height
	gib.velocity = Vector3(vel.x, vel.y, up_vel)
	gib.reset_physics_interpolation()
	return gib

func burst_gibs(amount: int, point: Vector2, height: float, base_vel: Vector2, speed: float, up_vel: float) -> void:
	for i in range(amount):
		var vel := base_vel + Vector2.from_angle(randf() * PI * 2) * speed * randf()
		spawn_gib(point, height, vel, up_vel - randf() * up_vel * 0.5)
