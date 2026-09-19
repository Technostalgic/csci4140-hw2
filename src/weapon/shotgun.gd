class_name Shotgun
extends Gun

@export var bullets_per_shot: int = 6
@export_flags_2d_physics var enemy_mask: int = 2
@export var spread: float = PI / 8
@export_range(0, 1) var evenly_spread_factor: float = 0.8

var _debug_lines: Array[Line2D] = []

func _fire_shot(direction: float):
	var line := Line2D.new()
	line.points = PackedVector2Array([
		Vector2.ZERO,
		Vector2(1000, 0)
	])
	line.width = 2
	line.default_color = Color("gold")
	add_child(line)
	line.global_position = projectile_spawnpoint.global_position
	line.global_rotation = direction
	_debug_lines.push_back(line)

func fire():
	for line in _debug_lines:
		line.queue_free()
	_debug_lines.clear()
		
	var spread_delta := (spread * evenly_spread_factor) / bullets_per_shot as float
	for i in range(bullets_per_shot):
		var direction_offset := (i - bullets_per_shot * 0.5 + 0.5) * spread_delta
		var spread_cone := spread / bullets_per_shot * (bullets_per_shot * (1 - evenly_spread_factor))
		direction_offset += (randf() - 0.5) * spread_cone
		var direction := projectile_spawnpoint.global_rotation + direction_offset
		_fire_shot(direction)
