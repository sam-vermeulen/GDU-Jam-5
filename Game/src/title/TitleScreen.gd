extends Control

func _ready():
	for button in $Menu/Center/Buttons.get_children():
		button.connect("pressed", self, "_on_Button_pressed", [button.target_scene])

func _on_Button_pressed(target_scene):
	if target_scene == "exit":
		get_tree().quit()
	else:
		get_tree().change_scene(target_scene)
