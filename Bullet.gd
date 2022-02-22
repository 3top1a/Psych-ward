extends RigidBody

func _ready():
	apply_impulse(transform.basis.z, -transform.basis.z * 20)

func _physics_process(delta):
	if global_transform.origin.y < 0.5:
		queue_free()
	look_at(get_viewport().get_camera().global_transform.origin, Vector3.UP)
