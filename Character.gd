extends KinematicBody

export var speed = 1.5
export var mouse_sensitivity = 0.01
export var gun_sensitivity = 1

export var ACCELERATION = 15.0
export var DEACCELERATION = 20.0

export var XSWAY = 20.0
export var YSWAY = 10.0

export onready var gun = $"Pivot/GunTween/Gun pivot"
export onready var hand = $"Pivot/GunTween"

var velocity = Vector3(0,0,0)
var gun_velocity = Vector3(0,0,0)

func _ready():
	gun.set_as_toplevel(true)

func _process(delta):
	gun.global_transform.origin = hand.global_transform.origin
	gun.rotation.y = lerp_angle(gun.rotation.y, rotation.y, XSWAY * delta)
	gun.rotation.x = lerp_angle(gun.rotation.x, $Pivot.rotation.x, YSWAY * delta)

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
	
	velocity.y = 0
	
	velocity = velocity.linear_interpolate(direction * speed, ACCELERATION * delta)
	
	velocity = move_and_slide_with_snap(velocity, Vector3(0.01,0.01,0.01), Vector3.UP, true)
	


func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Pivot.rotate_x(-event.relative.y * mouse_sensitivity)
		$Pivot.rotation.x = clamp($Pivot.rotation.x, -1.2, 1.2)
