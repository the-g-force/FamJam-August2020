extends Node2D

const _Crumb = preload("res://src/Crumb.tscn")
onready var _crumbs = $Crumbs

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.is_pressed():
			var crumb = _Crumb.instance()
			crumb.position = get_global_mouse_position()
			_crumbs.add_child(crumb)
