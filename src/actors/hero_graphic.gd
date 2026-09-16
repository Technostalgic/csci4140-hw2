class_name HeroGraphic
extends Node2D

@export var animation_player: AnimationPlayer = null

func play_idle_animation():
	animation_player.play("idle")


func play_walk_animation():
	animation_player.play("walk")
