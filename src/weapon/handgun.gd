class_name Handgun
extends Gun

@export var projectile: PackedScene = null
@export var muzzle_flash: PackedScene = null

func fire() -> void:
	ready_to_fire = false
	var flash: Node2D = muzzle_flash.instantiate()
	projectile_spawnpoint.add_child(flash)
	flash.position = Vector2.ZERO
	var bullet: Bullet = projectile.instantiate()
	get_tree().root.add_child(bullet)
	bullet.global_position = projectile_spawnpoint.global_position
	bullet.global_rotation = projectile_spawnpoint.global_rotation
