extends Tween


export (float) var timing = 0.5
export (Vector3) var offset = Vector3.ZERO
export (Vector3) var rotation_a = Vector3.ZERO

var time = timing 
var up = true

func _process(delta):
	time += delta
	
	if time > timing and up:
		var position = $"../Camera_Orientation".transform.origin
		var end_pos = $"../Camera_Orientation".transform.origin + offset
		
		var _rotation = $"../Camera_Orientation".rotation
		var end_rotation = $"../Camera_Orientation".rotation + rotation_a
		
		interpolate_property($"../Camera_Orientation", "translation",
		position, end_pos, timing,
		Tween.TRANS_BACK, Tween.EASE_IN_OUT)
		interpolate_property($"../Camera_Orientation", "rotation",
		_rotation, end_rotation, timing,
		Tween.TRANS_BACK, Tween.EASE_IN_OUT)
		start()
		
		time = 0.0
		up = false
	elif time > timing and not up:
		var position = $"../Camera_Orientation".transform.origin
		var end_pos = $"../Camera_Orientation".transform.origin - offset
		
		var _rotation = $"../Camera_Orientation".rotation
		var end_rotation = $"../Camera_Orientation".rotation - rotation_a
		
		interpolate_property($"../Camera_Orientation", "translation",
		position, end_pos, timing,
		Tween.TRANS_BACK, Tween.EASE_IN_OUT)
		interpolate_property($"../Camera_Orientation", "rotation",
		_rotation, end_rotation, timing,
		Tween.TRANS_BACK, Tween.EASE_IN_OUT)
		start()
		
		time = 0.0
		up = true
	
