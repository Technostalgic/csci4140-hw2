class_name SpriteAnimator
extends Sprite2D

@export var min_frame: int = 0
@export var max_frame: int = 0
@export var animation_rate: float = 30
@export var loop: bool = false
@export var autoplay: bool = false

var animation_delta: float = 0

func _ready() -> void:
	frame = min_frame
	if autoplay: play()
	else: hide()

func _process(delta: float) -> void:
	if not visible: return
	
	animation_delta += delta * animation_rate
	var cur_frame := floori(animation_delta) + min_frame
	var anim_range := max_frame - min_frame
	
	if cur_frame > max_frame:
		animation_delta = fmod(animation_delta, anim_range)
		cur_frame = floori(animation_delta) + min_frame
		if not loop:
			hide()
	
	frame = cur_frame

func play():
	show()
	animation_delta = 0
	frame = min_frame
