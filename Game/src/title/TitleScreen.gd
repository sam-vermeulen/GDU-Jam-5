extends Control

var load_scene
var muted = GameVariables.muted

func _ready():
	if muted == false:
		$AudioStreamPlayer.play()
	for button in $Menu/Center/Buttons.get_children():
		button.connect("pressed", self, "_on_Button_pressed", [button.target_scene])

func _on_Button_pressed(target_scene):
	load_scene = target_scene
	if target_scene == "exit":
		get_tree().quit()
	$FadeIn.show()
	$FadeIn.fade_in()

func _on_FadeIn_fade_finished():
	get_tree().change_scene(load_scene)

func _process(delta):
	if Input.is_action_just_pressed("Mute"):
		if muted:
			muted = false
			GameVariables.muted = false
			$AudioStreamPlayer.play()
		else:
			muted = true
			GameVariables.muted = true
			$AudioStreamPlayer.stop()
