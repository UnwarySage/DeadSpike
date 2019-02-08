extends RigidBody2D
class_name Enemy

signal on_damage
signal on_death
export var max_health :int 
export var armor_value :int = 0

onready var present_health :int = max_health

func damage(inp_amount):
	if(inp_amount - armor_value > 0):
		present_health += -inp_amount + armor_value
		#Trying to figure out what all needs to go into the event queue
		#emit_signal("on_damaged",{type = damage_notification, amount = inp_amount - armor_value, monter_instance = self})
		show_damage()
		if(present_health < 0):
			die()


func show_damage():
	modulate = Color(0,0,0,1)
	yield(get_tree().create_timer(.1), "timeout")
	modulate = Color(1,1,1,1)
	yield(get_tree().create_timer(.1), "timeout")
	modulate = Color(0,0,0,1)
	yield(get_tree().create_timer(.1), "timeout")
	modulate = Color(1,1,1,1)
	
	
func die():
	emit_signal("on_death",{"type": "death_nofitication", "monster" : self})
	queue_free()