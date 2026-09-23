extends Node2D

@onready var zom_killer = $AnimatedSprite2D

func _process(delta: float) -> void:
	if Input.is_action_pressed("move_up"):
		zom_killer.play('up_run')
	elif Input.is_action_just_released("move_up"):
		zom_killer.play('up_idle')
	elif Input.is_action_pressed("move_down"):
		zom_killer.play("down_run")
	elif Input.is_action_just_released("move_down"):
		zom_killer.play("down_idle")
	elif Input.is_action_pressed("move_left"):
		zom_killer.play("left_run")
	elif Input.is_action_just_released("move_left"):
		zom_killer.play("left_idle")
	elif Input.is_action_pressed("move_right"):
		zom_killer.play("right_run")
	elif Input.is_action_just_released("move_right"):
		zom_killer.play("right_idle")
		
