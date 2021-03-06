extends Node2D
class_name Stage
#Stage handles all the level related information, and generating the level
signal game_over

export var stage_width :int
export var stage_height :int

export (PackedScene) var player_scene
export (PackedScene) var hud_scene
export (PackedScene) var oasis_scene

export (PackedScene) var spawner_scene

export (PackedScene) var barrel_scene
export (PackedScene) var tumbleweed_scene


var player :Mage = null
var oasis = null


onready var _enemy_list = [barrel_scene, tumbleweed_scene]

func _ready():
	#setup background
	#$SandBackground.set_end(Vector2(stage_width,stage_height))
	var marker_list = _get_all_markers()
	_spawn_all(marker_list)
	_load_hud()

func _get_all_markers():
	var marker_list = []
	for child in get_children():
		if child is StartMarker:
			marker_list.append(child)
	return marker_list


func _spawn_all(list_of_markers):
	var player_spawned :bool = false
	var oasis_spawned:bool = false
	for mark in list_of_markers:
		if(mark.marked_type == mark.types["PLAYER"]):
			_load_player(mark.position)
			player_spawned = true
		elif (mark.marked_type == mark.types["ENEMY"]):
			_spawn_enemy(mark.global_position, _enemy_list[randi() % _enemy_list.size()])
		elif (mark.marked_type == mark.types["OASIS"]):
			if(!oasis_spawned):
				oasis = _generic_spawn(mark.position,oasis_scene)
				oasis_spawned = true
			
			


func _load_player(spawn_position :Vector2):
	var spawn :Mage = player_scene.instance()
	spawn.position = spawn_position
	spawn.stage = self
	player = spawn
	add_child(spawn)

func _load_hud():
	var spawn = hud_scene.instance()
	spawn.stage = self
	add_child(spawn)


func _generic_spawn(spawn_position :Vector2, type :PackedScene):
	var spawn = type.instance()
	spawn.position = spawn_position
	spawn.stage = self
	add_child(spawn)
	return spawn

func _spawn_enemy(spawn_position :Vector2, type :PackedScene):
	var spawn = spawner_scene.instance()
	spawn.position = spawn_position
	spawn.monster = type
	spawn.stage = self
	add_child(spawn)