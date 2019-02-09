extends "res://entity/enemy/Enemy.gd"

#moves close to the player, roots and becomes a turret.

var stage = null
export var contact_damage:float = 15
export var spine_damage:float = 10
export var root_range:float = 250
export var spine_range:float = 250
export var spine_count:int = 4
export var spine_life:float = 1
export var spine_speed:float = 400
export var spine_accuracy:float = 0.3

export (PackedScene) var spine_scene


var _rooted:bool = false


func _ready():
	$ShotTimer.wait_time= 2


func _physics_process(delta):
	if(stage != null && stage.player != null):
		if(!_rooted):
			applied_force = (stage.player.global_position - global_position).normalized() * 80
			if((global_position - stage.player.global_position).length() < root_range):
				_rooted = true
				linear_velocity = Vector2()
				mode = RigidBody2D.MODE_STATIC
				$ShotTimer.start()
			


func fire_salvo(count:int):
	for i in range(count):
		_shoot_spine(stage.player.global_position)
		yield(get_tree().create_timer(0.01),"timeout")

func _shoot_spine(target_position):
	var spawn=spine_scene.instance()
	spawn.setup(stage.player.global_position- global_position,spine_speed)
	spawn.accuracy = spine_accuracy
	spawn.lifetime = spine_life
	spawn.position = position
	stage.add_child(spawn)

func player_in_range():
	return (spine_range > (stage.player.global_position- global_position).length())


func _on_body_entered(body):
	if(body is Mage):
		body.damage(contact_damage)

func _on_ShotTimer_timeout():
	if(stage.player !=null && player_in_range()):
		fire_salvo(spine_count)
	$ShotTimer.start()
