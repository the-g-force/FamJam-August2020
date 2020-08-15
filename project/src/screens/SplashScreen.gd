extends Control

const _MainMenu : PackedScene = preload("res://src/screens/MainMenu.tscn")


func _ready():
	randomize()


func _input(event):
	if event is InputEventMouseButton:
		var _ignored_result = get_tree().change_scene_to(_MainMenu)
