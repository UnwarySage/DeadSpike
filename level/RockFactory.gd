extends Node2D

func _ready():
	var children = get_children()
	var chosen :int = randi() % children.size()
	print(children)
	remove_child(children[chosen])
	get_parent().add_child(children[chosen])
	children[chosen].global_position = global_position
	queue_free()