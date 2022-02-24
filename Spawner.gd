extends Spatial


export (Curve) var skulls
export var skull_pre = preload("res://Prefbs/SkullHead.tscn")
export (float) var skull_time = 10.0
export (float) var skull_dist = 80
export (float) var skull_amount = 10
var skull_timer = 0.0

var time = 0.0

func _process(delta):
	time += delta
	
	skull_timer += delta
	if skull_timer > skull_time:
		skull_timer = 0
		
		for x in range( int(skull_amount * skulls.interpolate(time / 1000)) ):
			var i = skull_pre.instance()
			i.global_transform.origin = $"../Player/Character".global_transform.origin + (Vector3.FORWARD * skull_dist).rotated(Vector3.UP, rand_range(0, 360))
			
			add_child(i)
