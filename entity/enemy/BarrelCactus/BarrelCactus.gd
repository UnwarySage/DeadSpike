extends "res://entity/enemy/Enemy.gd"

var stage = null

func _ready():
	print("growl")

func _physics_process(delta):
	if(stage != null && stage.player != null):
		applied_force = (stage.player.global_position - global_position).normalized() * 80