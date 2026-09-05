class_name Bullet
extends Area2D

@export var speed: float = 1000
@export var damage: float = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position += transform.basis_xform(Vector2.RIGHT) * speed * delta


func _on_body_entered(body: Node2D) -> void:
	if body is Hero: return
	queue_free()
	
	if body is Mob:
		body.take_damage(damage)
