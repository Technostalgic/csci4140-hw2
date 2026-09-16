class_name Impact
extends Node2D

@export var sprite: Sprite2D = null

func _ready():
	var tween = create_tween().set_parallel(true).set_ease(Tween.EASE_OUT)
	tween.tween_property(sprite, "scale", Vector2.ONE * 1.35, 0.3).from(Vector2.ONE * 0.6)
	tween.tween_property(sprite, "modulate:a", 0.0, 0.15).set_delay(0.15)
	tween.chain().tween_callback(queue_free)
