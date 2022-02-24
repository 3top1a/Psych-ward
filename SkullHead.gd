extends RigidBody

export var speed = 25.0
export var rot_speed = 3.5

export(Curve) var yCurve
export(float) var yHeight = 5
export(float) var yBaseHeight = 1.5
export(float) var yDist = 75.0

var target_position

func _process(delta):
	if !target_position:
		target_position = get_tree().get_root().get_node("Game/Player/Character/Pivot/Camera").global_transform
	
	$GFX.look_at(linear_velocity, Vector3.UP)
	pass

func _physics_process(delta):
	target_position = get_tree().get_root().get_node("Game/Player/Character/Pivot/Camera").global_transform
#	global_translate(
#		global_transform.origin.direction_to(get_tree().get_root().get_node("Game/Player/Character").global_transform.origin)
#		* speed * delta)
	
	var direction = target_position.origin - global_transform.origin
	direction = direction.normalized()
	
	var rot_am = direction.cross(global_transform.basis.z)
	rot_am.x = rot_am.x * delta * rot_speed
	rot_am.y = rot_am.y * delta * rot_speed
	
	rotate(Vector3.UP, rot_am.y)
	rotate(Vector3.RIGHT, rot_am.x)
	
	global_translate(-global_transform.basis.z * speed * delta)
	
	var yI = target_position.origin.distance_to(global_transform.origin)
	transform.origin.y = yBaseHeight + (yCurve.interpolate( min(yI / yDist, 1.0) ) * yHeight)
	
	if global_transform.origin.y < 0.0:
		queue_free()

func damage():
	queue_free()
