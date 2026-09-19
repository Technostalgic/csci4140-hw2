class_name GameOver
extends ColorRect

@export var hero: Hero = null
@export var sound_effect: AudioStream = null
@export var music: AudioStreamPlayer = null

func _ready() -> void:
	hero.die.connect(open)
	hide()

func open() -> void:
	
	# stop the music and play the sound effect
	music.stop()
	var audio := AudioStreamPlayer.new()
	audio.stream = sound_effect
	audio.finished.connect(audio.queue_free) # remove audio node when sound effect is done playing
	get_tree().root.add_child(audio)
	audio.play()
	
	# show the game over ui screen
	show()
