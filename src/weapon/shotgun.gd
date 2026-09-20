class_name Shotgun
extends Gun

@export var shoot_sound: AudioStream = null
@export var audio_player: AudioStreamPlayer = null
@export var raycast: RayCast2D = null
@export var bullets_per_shot: int = 6
@export var spread: float = PI / 8
@export_range(0, 1) var evenly_spread_factor: float = 0.8
@export var weapon_range: float = 1000
@export var damage: float = 1
@export var environmental_impact_effect: PackedScene = null

func _ready() -> void:
	super._ready()
	audio_player.stream = shoot_sound

func _fire_shot(direction: float):
	var endpoint = Vector2.from_angle(direction - projectile_spawnpoint.global_rotation) * weapon_range
	raycast.target_position = endpoint
	raycast.force_raycast_update()
	
	if raycast.is_colliding():
		var hit_obj := raycast.get_collider()
		if hit_obj is Mob:
			var mob := hit_obj as Mob
			if mob.health <= 0:
				raycast.add_exception(mob)
				_fire_shot(direction)
				return
			mob.take_damage(damage)
		
		var impact := environmental_impact_effect.instantiate() as Node2D
		get_tree().root.add_child(impact)
		impact.global_position = raycast.get_collision_point()

func fire():
	audio_player.play()
	
	# reset the raycast
	raycast.clear_exceptions()
	raycast.global_position = projectile_spawnpoint.global_position
	
	# fire a bullet across a random spread for each bullet in bullets_per_shot
	var spread_delta := (spread * evenly_spread_factor) / bullets_per_shot as float
	for i in range(bullets_per_shot):
		var direction_offset := (i - bullets_per_shot * 0.5 + 0.5) * spread_delta
		var spread_cone := spread / bullets_per_shot * (bullets_per_shot * (1 - evenly_spread_factor))
		direction_offset += (randf() - 0.5) * spread_cone
		var direction := projectile_spawnpoint.global_rotation + direction_offset
		_fire_shot(direction)
