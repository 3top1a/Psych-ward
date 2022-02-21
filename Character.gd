extends KinematicBody

export var speed = 1.5
export var mouse_sensitivity = 0.01

var velocity = Vector3(0,0,0)

func _physics_process(delta):
	var direction = Vector3.ZERO
	if Input.is_action_pressed("move_right"):
		direction += global_transform.basis.x
	if Input.is_action_pressed("move_left"):
		direction += -global_transform.basis.x
	if Input.is_action_pressed("move_down"):
		direction += global_transform.basis.z
	if Input.is_action_pressed("move_up"):
		direction += -global_transform.basis.z
	direction.normalized()
	
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	velocity.y = 0
	
	velocity = move_and_slide_with_snap(velocity, Vector3(0.01,0.01,0.01), Vector3(0, 1, 0), true)

func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Pivot.rotate_x(-event.relative.y * mouse_sensitivity)
		$Pivot.rotation.x = clamp($Pivot.rotation.x, -1.2, 1.2)
