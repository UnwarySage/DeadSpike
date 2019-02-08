extends RigidBody2D
class_name Mage

export var walk_force :float = 64

var _controllable :bool = true

func _physics_process(delta):
	#handling of movement
	self.applied_force = Vector2()
	#check if we can control ourselves
	if(_controllable):
		var direction :Vector2 = Vector2()
		if(Input.is_action_pressed("player_move_position")):
			direction = self.global_position - get_viewport().get_mouse_position()
			print(direction)
			direction = direction.normalized() * -1
			walk(direction)
		#now for keyboard inputs
		if(Input.is_action_pressed("player_move_down")):
			direction.y += 1
		if(Input.is_action_pressed("player_move_up")):
			direction.y -= 1
		if(Input.is_action_pressed("player_move_right")):
			direction.x += 1
		if(Input.is_action_pressed("player_move_left")):
			direction.x -= 1
		direction = direction.normalized()
		if(direction != Vector2()):
			walk(direction)
		
		

func walk(direction):
	direction = direction.normalized()
	self.applied_force = (walk_force * direction )

