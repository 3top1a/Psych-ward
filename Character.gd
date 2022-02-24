extends KinematicBody

export var DoJump = false
export var DoShoot = true

export var speed = 8
export var mouse_sensitivity = 0.01
export var gun_sensitivity = 1.0

export var ACCELERATION = 20.0
export var GRAVITY = 15.0
export var JUMP = 8.0
export var BULLET_SPEED = 20.0
export var SHOOT_TIME = .12

export var XSWAY = 20.0
export var YSWAY = 10.0
export var SWAY_SMOOTH = 1.0
export var SWAY_THRESHOLD = 1.0
export var SWAY_LEFT = Vector3()
export var SWAY_RIGHT = Vector3()
export var SWAY_NORMAL = Vector3()

export onready var gun = $"Pivot/GunTween/Gun pivot"
export onready var hand = $"Pivot/GunTween"

var gravity_velocity = 0
var shoot_timer = 0
var imaginary = false
var mouse_mov = Vector3()
var velocity = Vector3(0,0,0)
var gun_velocity = Vector3(0,0,0)

export onready var bullet = preload("res://Prefbs/Bullet.tscn")
export onready var imaginary_env = preload("res://Imaginary.tres")
export onready var real_env = preload("res://Real.tres")

func _ready():
	gun.set_as_toplevel(true)

func _process(delta):
	## Ground
	$"../Imaginary/Ground".material.set_shader_param("X", global_transform.origin.x)
	$"../Imaginary/Ground".material.set_shader_param("Y", global_transform.origin.z)
	
	## Sway
	gun.global_transform.origin = hand.global_transform.origin
	gun.rotation.y = lerp_angle(gun.rotation.y, rotation.y, XSWAY * delta)
	gun.rotation.x = lerp_angle(gun.rotation.x, $Pivot.rotation.x, YSWAY * delta)

#	if mouse_mov.x > SWAY_THRESHOLD:
#		gun.rotation = gun.rotation.linear_interpolate(SWAY_LEFT, SWAY_SMOOTH * delta)
#	elif mouse_mov.x < -SWAY_THRESHOLD:
#		gun.rotation = gun.rotation.linear_interpolate(SWAY_RIGHT, SWAY_SMOOTH * delta)
#	else:
#		gun.rotation = gun.rotation.linear_interpolate(SWAY_NORMAL, SWAY_SMOOTH * delta)
	
	### Positional sway
	
	#var sway_p = min(velocity.length(), 1.0)
#	$"Pivot/GunTween/Gun pivot/SwayPlayer".playback_speed = sway_p

func _physics_process(delta):
	## Pos copy
	
	$"../Imaginary".global_transform.origin.x = global_transform.origin.x
	$"../Imaginary".global_transform.origin.z = global_transform.origin.z
	
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
	if(DoJump):
		if not transform.origin.y < 0.01:
			gravity_velocity -= GRAVITY * delta
		
		if Input.is_action_just_pressed("jump") and transform.origin.y < 0.01:
			gravity_velocity = JUMP
		
		move_and_slide(Vector3(0, gravity_velocity, 0), Vector3.UP)
	else:
		if Input.is_action_just_pressed("jump"):
			imaginary = !imaginary
			
			$"../CanvasLayer/ColorRect/AnimationPlayer".play("Blink")
			
			switch()
	
	## Move
	velocity = velocity.linear_interpolate(direction * speed, ACCELERATION * delta)
	
	velocity = move_and_slide_with_snap(velocity, Vector3(0.01,0.01,0.01), Vector3.UP, true)
	## Ground
	
	if transform.origin.y < 0:
		transform.origin.y = 0
	
	## Shoot
	shoot_timer -= delta
	
	if Input.is_action_pressed("fire") and shoot_timer < 0.0 and imaginary and DoShoot:
		var i = bullet.instance()
		i.set_as_toplevel(true)
#		i.apply_impulse($Pivot/Camera/Position3D.transform.basis.z, -$Pivot/Camera.transform.basis.z * BULLET_SPEED)
#		i.velocity = -i.transform.basis.z * BULLET_SPEED
		i.apply_impulse(i.transform.basis.z, -$Pivot/Camera.global_transform.basis.z * BULLET_SPEED) 
		i.global_transform.origin = $Pivot/Camera/Position3D.global_transform.origin
		get_tree().get_root().add_child(i)
		shoot_timer = SHOOT_TIME

func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Pivot.rotate_x(-event.relative.y * mouse_sensitivity)
		$Pivot.rotation.x = clamp($Pivot.rotation.x, -1.2, 1.2)
		mouse_mov.x = -event.relative.x

func switch():
	if imaginary:
		$"../Imaginary".visible = true
		$"../Real".visible = false
		$"../Real/MeshInstance/ward_room/Camera/Camera_Orientation".current = false
		$"Pivot/Camera".current = true
		$"../Imaginary/CanvasLayer".scale = Vector2(1,1)
		$"../Real/CanvasLayer".scale = Vector2(0,0)
		
		$"../WorldEnvironment".set_environment(imaginary_env)
		
		$"../Real/breathing".playing = false
	else:
		$"../Imaginary".visible = false
		$"../Real".visible = true
		$"../Real/MeshInstance/ward_room/Camera/Camera_Orientation".current = true
		$"Pivot/Camera".current = false
		$"../Imaginary/CanvasLayer".scale = Vector2(0,0)
		$"../Real/CanvasLayer".scale = Vector2(1,1)
		
		$"../WorldEnvironment".set_environment(real_env)
		
		$"../Real/breathing".playing = true
		

func _on_Area_body_entered(body):
	if body.has_method("damage") and imaginary:
		get_tree().reload_current_scene()
