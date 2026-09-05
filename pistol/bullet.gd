class_name Bullet
extends Area2D

@export var impact: PackedScene = null
@export var speed: float = 1000
@export var damage: float = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position += transform.basis_xform(Vector2.RIGHT) * speed * delta


func _on_body_entered(body: Node2D) -> void:
	if body is Hero: return
	queue_free()
	
	var effect: Node2D = impact.instantiate()
	get_tree().root.add_child(effect)
	effect.global_position = global_position
	
	if body is Mob:
		body.take_damage(damage)
