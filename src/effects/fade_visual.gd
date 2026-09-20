class_name FadeVisual
extends Node

signal fade_complete(target: Node2D)

@export var target_graphic: Node2D = null
@export var fade_delay: float = 5
@export var fade_time: float = 1
@export var auto_reset: bool = true

var life: float = 0

func _enter_tree() -> void:
	if auto_reset: 
		target_graphic.show()
		life = 0
		target_graphic.modulate.a = 1

func _process(delta: float) -> void:
	if not target_graphic.visible: return
	
	life += delta
	if life < fade_delay: return
	
	var fade_delta = (life - fade_delay) / fade_time
	if fade_delta >= 1:
		target_graphic.hide()
		fade_complete.emit(target_graphic)
	target_graphic.modulate.a = 1 - fade_delta
