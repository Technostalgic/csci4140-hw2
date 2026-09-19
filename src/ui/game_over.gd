class_name GameOver
extends Control

@export var kills_value_text: Label = null
@export var sound_effect: AudioStream = null
@export var music: AudioStreamPlayer = null
@export var popup_delay: float = 1
@export var animation_time: float = 0.5

var _sound_played: bool = false
var game_scene: PackedScene = null
var anim_delta: float = 0

func _ready() -> void:
	Game.instance.hero.die.connect(open)
	hide()

func _process(delta: float) -> void:
	if visible:
		_handle_animation(delta)

func open() -> void:
	
	# update kills text
	kills_value_text.text = str(Game.instance.hero.kills)
	
	# reset animation
	_sound_played = false
	offset_transform_enabled = true
	anim_delta = -popup_delay
	modulate.a = 0
	
	# show the game over ui screen
	show()

func _retry_level() -> void:
	
	# find root game container
	var game_parent = get_parent()
	while game_parent:
		if game_parent is Game:
			break
		else:
			game_parent = game_parent.get_parent()
	
	var new_game := load(game_parent.scene_file_path).instantiate() as Game
	assert(new_game is Game)
	get_tree().root.add_child(new_game)
	game_parent.queue_free()

func _handle_animation(delta: float) -> void:
	anim_delta += delta
	if anim_delta < 0:
		return
	
	# stop the music and play the sound effect
	if not _sound_played:
		music.stop()
		var audio := AudioStreamPlayer.new()
		audio.stream = sound_effect
		audio.finished.connect(audio.queue_free) # remove audio node when sound effect is done playing
		get_tree().root.add_child(audio)
		audio.play()
		_sound_played = true
	
	if anim_delta >= animation_time:
		anim_delta = animation_time
		offset_transform_enabled = false
	var anim_progress: float = (anim_delta) / animation_time
	
	# pop-ease-in function
	var pop_delta = 1.1 * sin(0.5 * PI * (1.273 * anim_progress))
	
	modulate.a = pop_delta
	offset_transform_scale = Vector2.ONE * pop_delta * pop_delta
	offset_transform_rotation = pop_delta * PI + PI
