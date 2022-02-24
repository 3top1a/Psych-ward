extends Tween

var time = 0.0

func _process(delta):
	time += delta
	
	if time > 2.0:
		var position = $"../Camera_Orientation".global_transform.origin
		var end_pos = Vector3(position.x, position.y + 100, position.z)
		
		interpolate_property($"../Camera_Orientation", "position",
		position, end_pos, 1.8,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		start()
		
		time = 0.0
