class_name SelfDestruct extends Node

func use(body):
	print("BOOM " + str(body.position))

func get_cursor():
	return "res://assets/cursors/bombcursor.png"
	
