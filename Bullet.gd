extends RigidBody

var forward_dir = Vector3.ZERO

func _ready():
	randomize()
	$One.modulate = Color.darkgoldenrod.from_hsv(rand_range(0, 360), rand_range(0.5, 0.9), rand_range(0.4, 0.9))
	$Two.modulate = Color.darkgoldenrod.from_hsv(rand_range(0, 360), rand_range(015, 0.5), rand_range(0.1, 0.5))

func _physics_process(delta):
	global_translate(forward_dir * 5 * delta)
	if global_transform.origin.y < 0.5:
		queue_free()
	look_at(get_viewport().get_camera().global_transform.origin, Vector3.UP)


func _on_Bullet_body_entered(body):
	queue_free()
	if body.has_method("damage"):
		body.damage()
