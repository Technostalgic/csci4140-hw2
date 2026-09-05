class_name Game
extends Node2D

static var instance: Game = null

@export var hero: Hero = null

func _init() -> void:
	Game.instance = self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
