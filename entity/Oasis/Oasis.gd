extends Node2D

#spawner of water orbs to refuel the player
export var drop_time:float = 1
export var drop_value:float = 50
export (PackedScene) var orb_scene:PackedScene

var stage:Stage = null

var _active = false
var player:Mage = null


func spawn_orb():
	var spawn = orb_scene.instance()
	spawn.target = stage.player
	spawn.value = drop_value
	spawn.global_position = global_position
	spawn.position.x += randf() * 3 -1.5
	spawn.position.y += randf() * 3 -1.5
	stage.add_child(spawn)
	

func _on_OasisPickUpRadius_body_entered(body):
	if(body is Mage and !_active):
		_active = true
		spawn_orb()
		spawn_orb()
		spawn_orb()
		$OasisTimer.start()


func _on_OasisPickUpRadius_body_exited(body):
	if(body is Mage and _active):
		_active = false


func _on_OasisTimer_timeout():
	if(_active):
		spawn_orb()
		$OasisTimer.wait_time = drop_time
		$OasisTimer.start()
