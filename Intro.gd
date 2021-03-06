extends Spatial

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$Player/Score.visible = false
	$Player/Character.imaginary = false
	$Player/Character.switch()
	$Player/Character.visible = false
	$Player/Think.visible = true


func on_pill_taken(_body):
	$"Player/CanvasLayer/ColorRect/AnimationPlayer".play("Blink")
	yield(get_tree().create_timer(2.0/60.0), "timeout")
	get_tree().change_scene_to(preload("res://Game.tscn"))
