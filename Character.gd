extends KinematicBody

export var DoJump = false
export var DoShoot = true

export var speed = 8
export var mouse_sensitivity = 0.01
export var setting_mouse_sensitivity = 0.01
export var gun_sensitivity = 1.0

export var ACCELERATION = 20.0
export var GRAVITY = 15.0
export var JUMP = 8.0
export var BULLET_SPEED = 200.0
export var SHOOT_TIME = .09
export var SPHREAD = 15
export (Array, NodePath) var SHOTGUN_RAYS

export var XSWAY = 20.0
export var YSWAY = 10.0
export var SWAY_SMOOTH = 1.0
export var SWAY_THRESHOLD = 1.0
export var SWAY_LEFT = Vector3()
export var SWAY_RIGHT = Vector3()
export var SWAY_NORMAL = Vector3()

export onready var gun = $"Pivot/GunTween/Gun pivot"
export onready var hand = $"Pivot/GunTween"
export onready var pos3D = $Pivot/Camera/Position3D

var gravity_velocity = 0
var shoot_timer = 0
var imaginary = false
var mouse_mov = Vector3()
var velocity = Vector3(0,0,0)
var gun_velocity = Vector3(0,0,0)
var minigun = false

export onready var bullet = preload("res://Prefbs/Bullet.tscn")
export onready var imaginary_env = preload("res://Imaginary.tres")
export onready var real_env = preload("res://Real.tres")
export onready var bullet_snd = preload("res://Prefbs/BulletSound.tscn")

func _ready():
	gun.set_as_toplevel(true)
	randomize()
	var file = File.new()
	if file.file_exists("user://totally_not_just_your_sens.tres"):
		file.open("user://totally_not_just_your_sens.tres", File.READ)
		mouse_sensitivity = file.get_var()
		$"../Settings/VBoxContainer/SensS".value = mouse_sensitivity
		file.close()
	else:
		file = File.new()
		$"../Settings/VBoxContainer/SensS".value = mouse_sensitivity
		file.open("user://totally_not_just_your_sens.tres", File.WRITE)
		file.store_var(mouse_sensitivity, false)
		file.close()

func _process(delta):
	## Ground
	$"../Imaginary/Ground".material.set_shader_param("X", global_transform.origin.x)
	$"../Imaginary/Ground".material.set_shader_param("Y", global_transform.origin.z)

	## Sway
	gun.global_transform.origin = hand.global_transform.origin
	gun.rotation.y = lerp_angle(gun.rotation.y, rotation.y, XSWAY * delta)
	gun.rotation.x = lerp_angle(gun.rotation.x, $Pivot.rotation.x, YSWAY * delta)

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
			$"../Think".visible = false

			switch()

	## Move
	if imaginary:
		velocity = velocity.linear_interpolate(direction * speed, ACCELERATION * delta)
		velocity = move_and_slide_with_snap(velocity, Vector3(0.01,0.01,0.01), Vector3.UP, true)

	## Ground
	if transform.origin.y < 0:
		transform.origin.y = 0

	## Shoot
	shoot_timer -= delta

	if !(shoot_timer < 0.0 and imaginary and DoShoot):
		return

	if Input.is_action_pressed("fire"):
		shoot_rifle()

func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Pivot.rotate_x(-event.relative.y * mouse_sensitivity)
		$Pivot.rotation.x = clamp($Pivot.rotation.x, -1.2, 1.2)
		mouse_mov.x = -event.relative.x
	elif event is InputEventMouseButton:
		if event.doubleclick:
			shoot_gun()

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
		$"../Imaginary/north".playing = true
		visible = true
		#transform.origin = Vector3(0,0.5,0)
		if get_tree().get_current_scene().get_name() != "Intro":
			transform.origin = transform.origin + (Vector3.FORWARD * 100).rotated(Vector3.UP, rand_range(0, 360))

	else:
		$"../Imaginary".visible = false
		$"../Real".visible = true
		$"../Real/MeshInstance/ward_room/Camera/Camera_Orientation".current = true
		$"Pivot/Camera".current = false
		$"../Imaginary/CanvasLayer".scale = Vector2(0,0)
		$"../Real/CanvasLayer".scale = Vector2(1,1)
		
		$"../WorldEnvironment".set_environment(real_env)
		
		$"../Real/breathing".playing = true
		$"../Imaginary/north".playing = false
		visible = false

func _on_Area_body_entered(body):
	if body.has_method("damage") and imaginary:
		get_tree().get_root().get_node("Game").lose()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		$"../Settings".visible = !$"../Settings".visible
		if $"../Settings".visible:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func shoot_sound(_count = 1):
	# Sound
	for _i in range(_count):
		var sound = bullet_snd.instance()
		add_child(sound)
		yield(get_tree(), "idle_frame")

func shoot_rifle():
	if shoot_timer > 0:
		return

	var i = bullet.instance()
	i.set_as_toplevel(true)
	i.apply_impulse(i.transform.basis.z, -$Pivot/Camera.global_transform.basis.z * BULLET_SPEED)
	get_tree().get_root().add_child(i)
	i.global_transform.basis = pos3D.global_transform.basis
	i.global_transform.origin = pos3D.global_transform.origin
	if $Pivot/Camera/RayCast.is_colliding():
		var bullet = get_world().direct_space_state
		var collision = bullet.intersect_ray( $Pivot/Camera.global_transform.origin, $Pivot/Camera/RayCast.get_collision_point())
		if collision:
			var target = collision.collider
			if target.has_method("damage"):
				target.damage()
	shoot_timer = SHOOT_TIME

	# Sound
	shoot_sound(1)


func shoot_gun():
	if shoot_timer > 0:
		return

	for r in SHOTGUN_RAYS:
		get_node(r).cast_to.x = rand_range(SPHREAD, -SPHREAD)
		get_node(r).cast_to.y = rand_range(SPHREAD, -SPHREAD)

		var i = bullet.instance()
		i.set_as_toplevel(true)
		i.apply_impulse(i.transform.basis.z, -$Pivot/Camera.global_transform.basis.z * BULLET_SPEED)
		get_tree().get_root().add_child(i)
		var offset = (Vector3(get_node(r).cast_to.x * 2.0, get_node(r).cast_to.y, 0.0)*0.005)

		i.transform.origin = (pos3D.global_transform.origin + offset)
		i.apply_central_impulse((-$Pivot/Camera.global_transform.basis.z * BULLET_SPEED) + (offset * 1/0.005))

		if get_node(r).get_collider():
			var target = get_node(r).get_collider()
			if target.has_method("damage"):
				target.damage()
	shoot_timer = SHOOT_TIME * 5
	shoot_sound(3)


func _on_Exit_pressed():
	get_tree().quit()

func _on_SensS_value_changed(value):
	mouse_sensitivity = value
	var file = File.new()
	file.open("user://totally_not_just_your_sens.tres", File.WRITE)
	file.store_var(value, false)
	file.close()
