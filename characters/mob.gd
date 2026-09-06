class_name Mob
extends CharacterBody2D

var hero: Hero = null
@export var slime_node: Node2D = null
@export var death_fx: PackedScene = null
@export var movement_speed: float = 300
@export var health: float = 3

func _ready() -> void:
	hero = Game.instance.hero
	slime_node.play_walk()

func _physics_process(delta: float) -> void:
	var direction := (hero.global_position - global_position).normalized()
	velocity = direction * movement_speed
	move_and_slide()

func take_damage(damage: float) -> void:
	health -= damage
	slime_node.play_hurt()
	if health <= 0:
		var effect: Node2D = death_fx.instantiate()
		get_tree().root.add_child(effect)
		effect.global_position = global_position
		queue_free()
