class_name EffectSpawner
extends Node

@export var effect_base: Node2D = null
@export var randomize_h_flip: bool = false
@export var randomize_v_flip: bool = false
@export var angle_randomization: float = PI * 2
@export var pool_size: int = 10

var pool: Array[Node2D] = []

func _ready() -> void:
	for i in range(pool_size):
		pool.push_back(effect_base.duplicate())

func _get_pooled_item() -> Node2D:
	var item = pool.pop_back()
	if not item:
		item = effect_base.duplicate()
	self.add_child(item)
	return item

func _on_effect_complete(effect: Node2D) -> void:
	var parent := effect.get_parent()
	if parent:
		parent.remove_child(effect)
	pool.push_back(effect)

func spawn_effect(point: Vector2, direction: float) -> void:
	var fx := _get_pooled_item()
	if randomize_h_flip and randf() < 0.5:
		fx.scale.x *= -1
	if randomize_v_flip and randf() < 0.5:
		fx.scale.y *= -1
	fx.global_position = point
	fx.global_rotation = direction + angle_randomization * (randf() - 0.5)
