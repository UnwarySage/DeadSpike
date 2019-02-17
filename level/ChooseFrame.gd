extends AnimatedSprite


func _ready():
	frame = randi() % (frames.get_frame_count("default"))
	playing = false