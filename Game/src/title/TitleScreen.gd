extends Control

var load_scene

func _ready():
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
