extends KinematicBody2D

export var lifetime :float = 2
export var speed :float = 64
export var accuracy:float = 0.1
export var heading :Vector2 = Vector2(0,1)

func _ready():
	look_at(to_global(heading))

func _process(delta):
	var collision = move_and_collide(heading * speed)
	if (collision):
		print("blem")
		queue_free()


func _on_BoltTimer_timeout():
	queue_free()


func setup(inp_heading:Vector2, inp_speed:float = speed):
	heading = inp_heading.normalized()
	heading = heading.rotated(rand_range(-accuracy,accuracy))
	speed = inp_speed
	$BoltTimer.wait_time = lifetime
	$BoltTimer.start()
