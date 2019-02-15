extends RigidBody2D
class_name Mage

signal on_water_adjust
signal on_health_adjust

export (PackedScene) var bolt_scene = null

export var walk_force :float = 64
export var cooldown_rate:float = 1
export var max_water:float = 500 
export var max_health:float = 500

var stage = null
var _controllable :bool = true
var _spell_cooldown:float = 0
var _present_water:float = max_water
var _present_health:float = max_water

func _physics_process(delta):
	#handling of movement
	applied_force = Vector2()
	#check if we can control ourselves
	if(_controllable):
		var direction :Vector2 = Vector2()
		if(Input.is_action_pressed("player_move_position")):
			direction =  global_position - get_global_mouse_position()
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
	if(Input.is_action_pressed("player_cast_spell") and _spell_cooldown < 0 and _present_water > 0):
		cast_spell()
		
	else:
		#make our hand invisible
		$MageSprite/CastParticles.emitting = false


func damage(inp_amount):
	_adjust_present_health(-inp_amount)
	


func walk(direction):
	direction = direction.normalized()
	applied_force = (walk_force * direction)


func cast_spell():
	#make hand visible
	$MageSprite/MageHand.visible = true
	$MageSprite/CastParticles.emitting = true
	if(_controllable):
		cast_spray()

#spells--------------
func cast_wave():
	var amount:int = 30
	var accuracy:float = 0.4
	_spell_cooldown = 75
	_adjust_present_water(-100)
	for i in range(floor(amount/3)):
		_shoot_bolt(.25,500,accuracy,1)
		_shoot_bolt(.27,500,accuracy,.9)
		_shoot_bolt(.28,500,accuracy,.8)
		yield(get_tree().create_timer(.0001), "timeout")


func cast_raindrop():
	_adjust_present_water(-50)
	_spell_cooldown = 20
	_shoot_bolt(1.2,1200,0.001,30)


func cast_spray():
	_adjust_present_water(-5)
	_spell_cooldown = 2
	_shoot_bolt(1.2,700,0.05,5)


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
	

#Internal functions

func get_mouse_heading():
	return  (-1 * (global_position - get_global_mouse_position()).normalized() )

func _adjust_present_water(amount:float):
	_present_water += amount
	_present_water = clamp(_present_water,0,max_water)
	emit_signal("on_water_adjust", _present_water)

func _adjust_present_health(amount:float):
	_present_health += amount
	if(amount < 0):
		show_damage()
	if(_present_health < 0):
		_present_water = 0
		_controllable = false
	emit_signal("on_health_adjust", _present_health)

func show_damage():
	modulate = Color(0,0,0,1)
	yield(get_tree().create_timer(.1), "timeout")
	modulate = Color(1,1,1,1)
	yield(get_tree().create_timer(.1), "timeout")
	modulate = Color(0,0,0,1)
	yield(get_tree().create_timer(.1), "timeout")
	modulate = Color(1,1,1,1)