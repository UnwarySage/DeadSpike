extends RigidBody2D

var target = null
var value = 10

func _physics_process(delta):
	if(target != null):
		applied_force =  (target.global_position - global_position).normalized() * 60

func _on_body_entered(body):
	if(body is Mage):
		body._adjust_present_water(value)
		$WaterPelletSprite.visible=false
		$WaterTrail.emitting = false
		yield(get_tree().create_timer(1),"timeout")
		queue_free()
		