extends KinematicBody

export var speed = 1.5
export var mouse_sensitivity = 0.01
export var gun_sensitivity = 1

export var ACCELERATION = 15.0
export var DEACCELERATION = 20.0

export var XSWAY = 20.0
export var YSWAY = 10.0
export var SWAY_SMOOTH = 5
export var SWAY_THRESHOLD = 1
export var SWAY_LEFT = Vector3()
export var SWAY_RIGHT = Vector3()
export var SWAY_UP = Vector3()
export var SWAY_DOWN = Vector3()
export var SWAY_NORMAL = Vector3()

export onready var gun = $"Pivot/GunTween/Gun pivot"
export onready var hand = $"Pivot/GunTween"

var mouse_mov = Vector3()
var velocity = Vector3(0,0,0)
var gravity_velocity = Vector3(0,0,0)
var gun_velocity = Vector3(0,0,0)

func _ready():
	gun.set_as_toplevel(true)

func _process(delta):
	## Sway
	#gun.global_transform.origin = hand.global_transform.origin
	#gun.rotation.y = lerp_angle(gun.rotation.y, rotation.y, XSWAY * delta)
	#gun.rotation.x = lerp_angle(gun.rotation.x, $Pivot.rotation.x, YSWAY * delta)

	var sway = Vector3()
	if mouse_mov.x > SWAY_THRESHOLD:
		sway = gun.rotation.linear_interpolate(SWAY_LEFT, SWAY_SMOOTH * delta)
	if mouse_mov.x < -SWAY_THRESHOLD
		sway = gun.rotation.linear_interpolate(SWAY_RIGHT, SWAY_SMOOTH * delta)
	else:
		sway = gun.rotation.linear_interpolate(SWAY_NORMAL, SWAY_SMOOTH * delta)

	gun.rotation = gun.rotation.linear_interpolate(sway, SWAY_NORMAL, SWAY_SMOOTH * delta)

	### Positional sway

	var sway_p = min(velocity.length(), 1.0)

	$"Pivot/GunTween/Gun pivot/SwayPlayer".speed = swap_p

func _physics_process(delta):
	## Directionals
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

	## Jump & gravity
	if not is_on_floor():
		gravity_velocity -= gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor:
		gravity_velocity = jump

	move_and_slide(gravity_velocity, Vector3.UP)

	## Move
	velocity = velocity.linear_interpolate(direction * speed, ACCELERATION * delta)
	
	velocity = move_and_slide_with_snap(velocity, Vector3(0.01,0.01,0.01), Vector3.UP, true)

	## Ground
	
	if transform.origin.y < 0:
		transform.origin.y = 0


func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Pivot.rotate_x(-event.relative.y * mouse_sensitivity)
		$Pivot.rotation.x = clamp($Pivot.rotation.x, -1.2, 1.2)
		mouse_mov.x = -event.relative.x
		mouse_mov.y = -event.relative.y
