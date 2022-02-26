extends RigidBody

export (Vector2) var c1_h
export (Vector2) var c1_s
export (Vector2) var c1_v

export (Vector2) var c2_h
export (Vector2) var c2_s
export (Vector2) var c2_v

func _ready():
	randomize()
	randomize()
	$MeshInstance.get_surface_material(0).set_shader_param("color1", Color.from_hsv(rand_range(c1_h.x, c1_h.y),rand_range(c1_s.x, c1_s.y),rand_range(c1_v.x, c1_v.y),1))
	$MeshInstance.get_surface_material(0).set_shader_param("color2", Color.from_hsv(rand_range(c2_h.x, c2_h.y),rand_range(c2_s.x, c2_s.y),rand_range(c2_v.x, c2_v.y),1))

func _on_Bullet_body_entered(body):
	if body.has_method("damage"):
		body.damage()
	queue_free()

func _physics_process(delta):
	if global_transform.origin.y < 0.0:
		queue_free()

func _on_Timer_timeout():
	queue_free()
