extends Position2D

#Spawns monsters whenever offscreen

#this is to be added by stage when it loads in
var monster:PackedScene = null
var stage:Stage = null




	
func spawn_creature():
	var spawn = monster.instance()
	spawn.global_position = global_position
	spawn.stage = stage
	stage.add_child(spawn)


func _on_VisibilityNotifier2D_viewport_exited(viewport):
	spawn_creature()
