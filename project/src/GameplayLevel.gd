extends Node2D

const _Crumb = preload("res://src/Crumb.tscn")
const _throw_origin = Vector2(512,300)

# How long is the crumb "in the air"?
export var toss_duration := 1.1
# How many crumbs to load up per second
export var crumbs_load_rate : float = 0.5
# How wide does a cluster of crumbs spread?
export var crumbs_spread_radius : float = 20

var _pressed := false
var _seconds : float = 0

onready var _crumbs = $Crumbs
onready var _crumbs_label = $Control/Label
onready var _crumbs_progress : ProgressBar = $Control/ProgressBar

func _process(delta):
	if _pressed:
		_seconds += delta
		_crumbs_label.text = str(_crumbs_to_throw())
		_crumbs_progress.value = fmod(_seconds, crumbs_load_rate) / crumbs_load_rate * 100
	else:
		_crumbs_label.text = ''
		_crumbs_progress.value = 0


func _crumbs_to_throw() -> float:
	return floor(_seconds / crumbs_load_rate)


func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.is_pressed():
			_pressed = true
			_seconds = 0
		else:
			_pressed = false
			_throw_crumbs()


func _throw_crumbs():
	var crumbs_to_throw := _crumbs_to_throw()
	print('Throwing ' + str(crumbs_to_throw))
	for _x in range(_crumbs_to_throw()):
		var crumb : Crumb = _Crumb.instance()
		crumb.on_ground = false
		_crumbs.add_child(crumb)
		var target = get_global_mouse_position() \
		+ Vector2(rand_range(-crumbs_spread_radius, crumbs_spread_radius), \
		 			rand_range(-crumbs_spread_radius, crumbs_spread_radius))
		
		var tween = Tween.new()
		add_child(tween)
		tween.interpolate_property(crumb, "position", _throw_origin, target, toss_duration, Tween.TRANS_QUAD, Tween.EASE_OUT)
		tween.start()
		tween.connect("tween_all_completed", self, '_on_tween_complete', [tween, crumb], CONNECT_ONESHOT)


func _on_tween_complete(tween:Tween, crumb:Crumb):
	crumb.on_ground = true
	tween.queue_free()
