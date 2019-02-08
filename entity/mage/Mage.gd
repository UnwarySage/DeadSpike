extends RigidBody2D
class_name Mage

export (PackedScene) var bolt_scene = null

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
	#handle casting
	if(Input.is_action_pressed("player_cast_spell")):
		cast_spell()
	else:
		#make our hand invisible
		$MageSprite/MageHand.visible = false
		$MageSprite/CastParticles.emitting = false


func walk(direction):
	direction = direction.normalized()
	self.applied_force = (walk_force * direction)


func cast_spell():
	#make hand visible
	$MageSprite/MageHand.visible = true
	$MageSprite/CastParticles.emitting = true
	#this will automatically choose the most powerful one availible
	if(_controllable):
		_shoot_bolt()
	
func _shoot_bolt():
	var spawn = bolt_scene.instance()
	spawn.global_position = $MageSprite/MageHand/CastPosition.global_position
	
	spawn.setup(get_mouse_heading())
	#this should be area manager
	self.get_parent().add_child(spawn)

func get_mouse_heading():
	return  (-1 * (self.global_position - get_viewport().get_mouse_position()).normalized())