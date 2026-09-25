extends AnimatedSprite2D

@onready var small_zom = %AnimatedSprite2D

func _process(delta: float) -> void:
		small_zom.play("down_walk")
