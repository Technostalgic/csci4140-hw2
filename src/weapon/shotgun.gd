class_name Shotgun
extends Gun

@export var hero: Hero = null
@export var audio_player: AudioStreamPlayer = null
@export var raycast: RayCast2D = null
@export var muzzle_flash: SpriteAnimator = null
@export var impact_effects: EffectSpawner = null
@export var bullets_per_shot: int = 6
@export var spread: float = PI / 8
@export_range(0, 1) var evenly_spread_factor: float = 0.8
@export var weapon_range: float = 1000
@export var damage: float = 1
@export var trail_fade_rate: float = 20

var bullet_trail_pool: Array[Line2D] = []
var _cur_trail_index: int = 0

func _ready() -> void:
	super._ready()
	_pool_trails()

func _process(delta: float) -> void:
	_fade_trails(delta)
	super._process(delta)

func _pool_trails() -> void:
	_cur_trail_index = 0
	for i in range(10):
		var trail = Line2D.new()
		trail.width = 3
		trail.default_color = Color("gold")
		trail.points = PackedVector2Array([
			Vector2.ZERO,
			Vector2(1, 0),
		])
		get_tree().root.add_child.call_deferred(trail)
		bullet_trail_pool.push_back(trail)
		trail.modulate.a = 0

func _fade_trails(delta: float) -> void:
	for trail in bullet_trail_pool:
		trail.modulate.a -= delta * trail_fade_rate

func get_trail() -> Line2D:
	_cur_trail_index += 1
	if _cur_trail_index >= bullet_trail_pool.size():
		_cur_trail_index = 0
	return bullet_trail_pool[_cur_trail_index]

func _fire_shot(direction: float):
	
	# raycast collision query
	var endpoint = Vector2.from_angle(direction - projectile_spawnpoint.global_rotation) * weapon_range
	if projectile_spawnpoint.global_scale.y < 0:
		endpoint.y *= -1
	raycast.target_position = endpoint
	raycast.force_raycast_update()
	
	var trail_length := weapon_range
	
	# damage any objects the raycast hits
	if raycast.is_colliding():
		var hit_obj := raycast.get_collider()
		var hit_point :=  raycast.get_collision_point()
		if hit_obj is Mob:
			var mob := hit_obj as Mob
			
			# if the mob is already dead, ignore this hit and rerun collision
			if mob.health <= 0:
				raycast.add_exception(mob)
				_fire_shot(direction)
				return
			
			# hit mob
			mob.knockback(Vector2.from_angle(direction) * 750)
			mob.take_damage(damage)
			Game.instance.gibs.burst_gibs(
				1, hit_point, 32,
				mob.velocity * (randf() * 0.5 - 0.25), 800 + randf() * 300, 500
			)
		
		trail_length = hit_point.distance_to(raycast.global_position)
		
		# create impact effect
		impact_effects.spawn_effect(hit_point, raycast.get_collision_normal().angle() + PI * 0.5)
	
	# create bullet trail
	var trail = get_trail()
	trail.global_position = raycast.global_position
	trail.global_rotation = direction
	trail.scale.x = trail_length
	trail.modulate.a = 1

func fire():
	muzzle_flash.play()
	audio_player.play()
	
	# reset the raycast
	raycast.clear_exceptions()
	raycast.global_position = projectile_spawnpoint.global_position
	
	# fire a bullet across a random spread for each bullet in bullets_per_shot
	var fire_direction := projectile_spawnpoint.global_rotation
	var spread_delta := (spread * evenly_spread_factor) / bullets_per_shot as float
	for i in range(bullets_per_shot):
		var direction_offset := (i - bullets_per_shot * 0.5 + 0.5) * spread_delta
		var spread_cone := spread / bullets_per_shot * (bullets_per_shot * (1 - evenly_spread_factor))
		direction_offset += (randf() - 0.5) * spread_cone
		var direction := fire_direction + direction_offset
		_fire_shot(direction)
		
	# apply recoil
	hero.knockback(Vector2.from_angle(fire_direction) * -1000)
