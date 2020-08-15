extends Node2D

const _Crumb = preload("res://src/Crumb.tscn")
const _throw_origin = Vector2(512,300)

# How long is the crumb "in the air"?
export var toss_duration := 1.1

onready var _crumbs = $Crumbs


func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.is_pressed():
			var crumb : Crumb = _Crumb.instance()
			crumb.on_ground = false
			_crumbs.add_child(crumb)
			var target = get_global_mouse_position()
			
			var tween = Tween.new()
			add_child(tween)
			tween.interpolate_property(crumb, "position", _throw_origin, target, toss_duration, Tween.TRANS_QUAD, Tween.EASE_OUT)
			tween.start()
			yield(tween, "tween_completed")
			crumb.on_ground = true
			tween.queue_free()
