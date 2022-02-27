extends Spatial

export (float) var score = 0
var hs = -1

func _ready():
	$"Player/CanvasLayer/ColorRect/AnimationPlayer".play("Blink", 2.0/60.0)
	$Player/Character.imaginary = true
	$Player/Character.switch()
	$Player/Character.DoShoot = true

	var file = File.new()
	if file.file_exists("user://totally_not_just_your_score.dat"):
		file.open("user://totally_not_just_your_score.dat", File.READ)
		hs = file.get_var()
		file.close()

func _physics_process(delta):
	if $"Player/Character".imaginary:
		score += delta
	$Player/Score.text = "Score: %10.1f \nHS: %10.1f" % [score, hs]

func lose():
	if score > hs:
		var file = File.new()
		file.open("user://totally_not_just_your_score.dat", File.WRITE)
		file.store_var(score, false)
		file.close()

	$"Player/CanvasLayer/ColorRect/AnimationPlayer".play("Blink")
	yield(get_tree().create_timer(2.0/60.0), "timeout")
	get_tree().reload_current_scene()
