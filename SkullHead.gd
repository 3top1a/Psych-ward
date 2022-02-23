extends RigidBody

export var speed = 5
export var rot_speed = 5

func _physics_process(delta):
	var target_position = get_tree().get_root().get_node("Game/Player/Character").global_transform
	
	global_translate(
		global_transform.origin.direction_to(get_tree().get_root().get_node("Game/Player/Character").global_transform.origin)
		* speed * delta)
	
	if global_transform.origin.y < 0.5:
		queue_free()
