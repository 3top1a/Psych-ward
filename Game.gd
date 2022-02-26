extends Spatial

export (float) var score = 0
var hs = -1

func _ready():
	$"Player/CanvasLayer/ColorRect/AnimationPlayer".play("Blink", 2.0/60.0)
	$Player/Character.imaginary = true
	$Player/Character.switch()
	$Player/Character.DoShoot = true
	if ResourceLoader.exists("sekrit.tres"):
		var _hs = ResourceLoader.load("sekrit.tres")
		if _hs is skore_a:
			hs = _hs.score

func _physics_process(delta):
	if $"Player/Character".imaginary:
		score += delta
	$Player/Score.text = "Score: %10.1f \nHS: %10.1f" % [score, hs]

func lose():
	if ResourceLoader.exists("sekrit.tres"):
		var _hs = ResourceLoader.load("sekrit.tres")
		if (_hs is skore_a and _hs.score < score):
			var a = skore_a.new()
			a.score = score
			ResourceSaver.save("sekrit.tres", a)
	else:
		var a = skore_a.new()
		a.score = score
		ResourceSaver.save("sekrit.tres", a)
	
	$"Player/CanvasLayer/ColorRect/AnimationPlayer".play("Blink")
	yield(get_tree().create_timer(2.0/60.0), "timeout")
	get_tree().reload_current_scene()
