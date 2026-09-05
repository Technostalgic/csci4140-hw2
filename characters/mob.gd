class_name Mob
extends CharacterBody2D

var hero: Hero = null
@export var slime_node: Node2D = null
@export var movement_speed: float = 500

func _ready() -> void:
	hero = Game.instance.hero
	slime_node.play_walk()

func _physics_process(delta: float) -> void:
	var direction := (hero.global_position - global_position).normalized()
	velocity = direction * movement_speed
	move_and_slide()
