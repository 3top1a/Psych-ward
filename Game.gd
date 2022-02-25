extends Spatial

var score = 0
var hs = -1

func _ready():
	$Player/Character.imaginary = true
	$Player/Character.switch()
	$Player/Character.DoShoot = true
	if ResourceLoader.exists("sekrit.data"):
		var _hs = ResourceLoader.read("sekrit.data")
		if _hs is float:
			hs = _hs

func _physics_process(delta):
	score += delta

	$Player/Score.text = "Score: %10.1f \n HS: %10.1f" % [score, hs]

func lose():
	if ResourceLoader.exists("sekrit.data"):
		var _hs = ResourceLoader.read("sekrit.data")
		if _hs is float:
			ResourceSaver("", )
