extends Spatial

func _ready():
	$Player/Character.imaginary = true
	$Player/Character.switch()
	$Player/Character.DoShoot = true