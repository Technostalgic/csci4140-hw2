class_name Mob
extends CharacterBody2D

signal on_hurt()

var hero: Hero = null
@export var slime_node: Node2D = null
@export var movement_speed: float = 300
@export var health: float = 2
@export var knockback_decay: float = 3000

var parent_game: Game = null
var knockback_velocity = Vector2.ZERO

func _ready() -> void:
	hero = Game.instance.hero
	slime_node.play_walk()

func _physics_process(delta: float) -> void:
	var movement := Vector2.ZERO
	if hero: 
		movement = (hero.global_position - global_position).normalized() * movement_speed
	velocity = movement + knockback_velocity
	move_and_slide()
	
	# knockback velocity friction
	if knockback_velocity.length_squared() >= 1:
		knockback_velocity -= knockback_velocity.normalized() * knockback_decay * delta
		if knockback_velocity.length_squared() <= 1:
			knockback_velocity = Vector2.ZERO

func _death_effect() -> void:
	Game.instance.gibs.burst_gibs(
		4, global_position, 16,
		knockback_velocity.normalized() * 600, 400 + randf() * 300, 100
	)

func take_damage(damage: float) -> void:
	health -= damage
	slime_node.play_hurt()
	on_hurt.emit()
	if health <= 0:
		kill()

func knockback(force: Vector2) -> void:
	knockback_velocity += force

func kill() -> void:
	_death_effect()
	queue_free()
	parent_game.zombie_death(global_position)
	if hero:
		hero.kills += 1
