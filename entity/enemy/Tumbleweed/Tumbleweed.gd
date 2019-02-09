extends "res://entity/enemy/Enemy.gd"

var stage = null
export var contact_damage:float = 22

func _physics_process(delta):
	if(stage.player != null):
		applied_force = (stage.player.global_position - global_position).normalized() * 80

func _on_body_entered(body):
	if (body is Mage):
		body.damage(contact_damage)
		apply_impulse(Vector2(),(stage.player.global_position - global_position) * -5)
		
