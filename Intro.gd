extends Spatial

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$Player/Character.imaginary = false
	$Player/Score.visible = false
	$Player/Character.switch()

func on_pill_taken(_body):
	$"Player/CanvasLayer/ColorRect/AnimationPlayer".play("Blink")
	yield(get_tree().create_timer(2.0/60.0), "timeout")
	get_tree().change_scene_to(preload("res://Game.tscn"))
