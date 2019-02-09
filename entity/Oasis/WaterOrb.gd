extends RigidBody2D

var target = null
var value = 10

func _physics_process(delta):
	if(target != null):
		print(target)
		applied_force =  (target.global_position - global_position).normalized() * 60

func _on_body_entered(body):
	if(body is Mage):
		self.queue_free()
		body._adjust_present_water(value)
