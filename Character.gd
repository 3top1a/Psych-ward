extends KinematicBody

export var speed = 1.5

var velocity = Vector3(0,0,0)

func _physics_process(delta):
	var direction = Vector3.ZERO
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
	
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$Pivot.look_at(translation + direction, Vector3.UP)
	
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	velocity.y = 0
	
	velocity = move_and_slide_with_snap(velocity, Vector3(0.01,0.01,0.01), Vector3(0, 1, 0))
