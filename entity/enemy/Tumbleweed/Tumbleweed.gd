extends "res://entity/enemy/Enemy.gd"

var stage = null
export var contact_damage:float = 22
export var move_force:float = 200

func _physics_process(delta):
	if(stage.player != null):
		var steering_velocity:Vector2 = (stage.player.global_position-global_position ).normalized() *move_force
		applied_force = (steering_velocity - linear_velocity)

func _on_body_entered(body):
	if (body is Mage):
		body.damage(contact_damage)
		apply_impulse(Vector2(),(stage.player.global_position - global_position).normalized() * -500)
