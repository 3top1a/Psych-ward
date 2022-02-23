extends RigidBody

func _ready():
	randomize()
#	$One.modulate = Color.darkgoldenrod.from_hsv(rand_range(0, 360), rand_range(0.5, 0.9), rand_range(0.4, 0.9))
#	$Two.modulate = Color.darkgoldenrod.from_hsv(rand_range(0, 360), rand_range(015, 0.5), rand_range(0.1, 0.5))

func _on_Bullet_body_entered(body):
	queue_free()
	if body.has_method("damage"):
		body.damage()
