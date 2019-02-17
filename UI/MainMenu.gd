extends Control

var menu_active:bool = true

export (PackedScene) var level_scene

onready var playbutton:Button = find_node("PlayButton",true)
onready var creditbutton:Button = find_node("CreditsButton",true)
onready var exitbutton:Button = find_node("ExitButton",true)

var _stage

func _ready():
	print("MAIN MENU LOADED")
	playbutton.connect("button_down", self, "start_game")
	creditbutton.connect("button_down",self,"show_credits")
	exitbutton.connect("button_down",self,"exit_game")
	$AudioStreamPlayer.play()

func start_game():
	menu_active = false
	visible = false
	var spawn = level_scene.instance()
	get_parent().add_child(spawn)
	spawn.connect("game_over",self, "show_menu")
	_stage = spawn

func show_menu():
	print("Hello")
	if(_stage != null):
		_stage.queue_free()
	menu_active = true
	visible = true
	$AudioStreamPlayer.play()

func exit_game():
	get_tree().quit()


func _on_AudioStreamPlayer_finished():
	$AudioStreamPlayer.stop()