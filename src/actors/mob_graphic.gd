class_name MobGraphic
extends Node2D

@export var animation_player: AnimationPlayer = null

func play_walk():
	animation_player.play("walk")

func play_hurt():
	animation_player.play("hurt")
	animation_player.queue("walk")
