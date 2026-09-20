class_name Mob
extends CharacterBody2D

var hero: Hero = null
@export var slime_node: Node2D = null
@export var death_fx: PackedScene = null
@export var movement_speed: float = 300
@export var health: float = 2
@export var knockback_decay: float = 3000

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

func take_damage(damage: float) -> void:
	health -= damage
	slime_node.play_hurt()
	if health <= 0:
		kill()

func knockback(force: Vector2) -> void:
	knockback_velocity += force

func kill() -> void:
	var effect: Node2D = death_fx.instantiate()
	get_tree().root.add_child(effect)
	effect.global_position = global_position
	queue_free()
	if hero:
		hero.kills += 1
