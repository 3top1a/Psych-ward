extends RigidBody

func _ready():
	apply_impulse(transform.basis.z, -transform.basis.z * 20)
	randomize()
	$One.modulate = Color.darkgoldenrod.from_hsv(rand_range(0, 360), rand_range(0.5, 0.9), rand_range(0.4, 0.9))
	$Two.modulate = Color.darkgoldenrod.from_hsv(rand_range(0, 360), rand_range(015, 0.5), rand_range(0.1, 0.5))

func _physics_process(delta):
	if global_transform.origin.y < 0.5:
		queue_free()
	look_at(get_viewport().get_camera().global_transform.origin, Vector3.UP)
