extends Area2D

var overlapping_mobs: Array[CharacterBody2D] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var closest_mob = get_closest_mob()
	if closest_mob != null:
		var difference: Vector2 = closest_mob.global_position - global_position
		var direction := atan2(difference.y, difference.x)
		global_rotation = direction
		

func get_closest_mob() -> CharacterBody2D:
	if len(overlapping_mobs) <= 0: return null
	
	var closest_distance: float = INF
	var closest_mob: CharacterBody2D = null
	for mob in overlapping_mobs:
		var distance = (mob.global_position - global_position).length_squared()
		if distance < closest_distance:
			closest_distance = distance
			closest_mob = mob
	
	return closest_mob


func _on_body_entered(body: Node2D) -> void:
	if body is Mob:
		overlapping_mobs.append(body)


func _on_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		var index = overlapping_mobs.find(body)
		if index >= 0:
			overlapping_mobs.remove_at(index)
