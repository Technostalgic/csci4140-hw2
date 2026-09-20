class_name EffectSpawner
extends Node2D

@export var effect_base: Node2D = null
@export var randomize_h_flip: bool = false
@export var randomize_v_flip: bool = false
@export var angle_randomization: float = PI * 2
@export var pool_size: int = 10
@export var container_node: Node2D = null
@export var use_lifetimes: bool = false
@export var max_lifetime: float = 1

var pool: Array[Node2D] = []
var active_effects: Array[Node2D] = []
var lifetimes: Array[float] = []

func _ready() -> void:
	reparent.call_deferred(get_tree().root, false)
	if not container_node: container_node = self
	for i in range(pool_size):
		pool.push_back(effect_base.duplicate())
	_pool_object(effect_base)

func _process(delta: float) -> void:
	if not use_lifetimes:
		return

	for i in range(lifetimes.size()):
		lifetimes[i] += delta

	while lifetimes and lifetimes[0] >= max_lifetime:
		lifetimes.pop_front()
		_pool_object(active_effects.pop_front())

func _pool_object(obj: Node2D) -> void:
	var parent := obj.get_parent()
	if parent:
		parent.remove_child(obj)
	pool.push_back(obj)

func _get_pooled_item() -> Node2D:
	var item = pool.pop_back()
	if not item:
		item = effect_base.duplicate()
	container_node.add_child(item)
	if use_lifetimes:
		lifetimes.push_back(0)
		active_effects.push_back(item)
	return item

func _on_effect_complete(effect: Node2D) -> void:
	if not use_lifetimes:
		_pool_object(effect)
	else:
		effect.hide()

func spawn_effect(point: Vector2, direction: float) -> Node2D:
	var fx := _get_pooled_item()
	if randomize_h_flip and randf() < 0.5:
		fx.scale.x *= -1
	if randomize_v_flip and randf() < 0.5:
		fx.scale.y *= -1
	fx.global_position = point
	fx.global_rotation = direction + angle_randomization * (randf() - 0.5)
	fx.reset_physics_interpolation()
	return fx
