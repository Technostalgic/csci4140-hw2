class_name Game
extends Node2D

static var instance: Game = null

@export var hero: Hero = null
@export var slime_spawner: PathFollow2D = null
@export var slime_scene: PackedScene = null

func _init() -> void:
	Game.instance = self

func spawn_mob() -> void:
	slime_spawner.progress_ratio = randf()
	var slime: Mob = slime_scene.instantiate()
	get_tree().root.add_child(slime)
	slime.global_position = slime_spawner.global_position
