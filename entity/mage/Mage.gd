extends RigidBody2D
class_name Mage

export (PackedScene) var bolt_scene = null

export var walk_force :float = 64
export var cooldown_rate:float = 1

var stage = null
var _controllable :bool = true
var _spell_cooldown:float = 0


func _physics_process(delta):
	#handling of movement
	applied_force = Vector2()
	#check if we can control ourselves
	if(_controllable):
		var direction :Vector2 = Vector2()
		if(Input.is_action_pressed("player_move_position")):
			direction = global_position - get_viewport().get_mouse_position()
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
	if(_spell_cooldown >= 0):
		_spell_cooldown -= cooldown_rate
		$MageSprite/MageHand.visible= false
	else:
		$MageSprite/MageHand.visible = true
	if(Input.is_action_pressed("player_cast_spell") and _spell_cooldown < 0):
		cast_spell()
		
	else:
		#make our hand invisible
		$MageSprite/CastParticles.emitting = false


func walk(direction):
	direction = direction.normalized()
	applied_force = (walk_force * direction)


func cast_spell():
	#make hand visible
	$MageSprite/MageHand.visible = true
	$MageSprite/CastParticles.emitting = true
	if(_controllable):
		cast_spray(30,.7)
#spells
func cast_spray(amount:int, accuracy:float):
	_spell_cooldown = 75
	for i in range(floor(amount/3)):
		_shoot_bolt(.25,500,accuracy,1)
		_shoot_bolt(.27,500,accuracy,.9)
		_shoot_bolt(.28,500,accuracy,.8)
		yield(get_tree().create_timer(.0001), "timeout")

func _shoot_bolt(lifetime:float ,speed:float,accuracy:float, damage :int = 5):
	#shoots a single bolt. Can be used solo, or as part of a larger spell
	var spawn = bolt_scene.instance()
	spawn.global_position = $MageSprite/MageHand/CastPosition.global_position
	spawn.lifetime = lifetime
	spawn.accuracy = accuracy
	spawn.speed = speed
	spawn.damage_inflicted = damage
	spawn.setup(get_mouse_heading())
	#this should be area manager
	get_parent().add_child(spawn)

func get_mouse_heading():
	return  (-1 * (global_position - get_viewport().get_mouse_position()).normalized())