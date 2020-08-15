extends Node2D

const _Crumb = preload("res://src/Crumb.tscn")
const _Bird = preload("res://src/Bird.tscn")

# How long is the crumb "in the air"?
export var toss_duration := 1.1
# How many crumbs to load up per second
export var crumbs_load_rate : float = 0.5
# How wide does a cluster of crumbs spread?
export var crumbs_spread_radius : float = 20

var _pressed := false
var difficulty_level := 1
var bird_count := 0
var _seconds : float = 0

onready var _crumbs = $Crumbs
onready var _crumbs_label = $Control/Label
onready var _crumbs_progress : ProgressBar = $Control/ProgressBar
onready var _birdspawnlocation : PathFollow2D = $Path2D/PathFollow2D
# The node whose location the crumbs spawn from
onready var _hand : Node2D = $Hand

func _ready():
	randomize()
	spawn_wave()


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
	for _x in range(_crumbs_to_throw()):
		var crumb : Crumb = _Crumb.instance()
		crumb.on_ground = false
		_crumbs.add_child(crumb)
		var target = get_global_mouse_position() \
				+ Vector2(rand_range(-crumbs_spread_radius, crumbs_spread_radius), \
		 			rand_range(-crumbs_spread_radius, crumbs_spread_radius))
		
		var tween = Tween.new()
		add_child(tween)
		tween.interpolate_property(crumb, "position", _hand.get_global_transform().origin, target, toss_duration, Tween.TRANS_QUAD, Tween.EASE_OUT)
		tween.start()
		tween.connect("tween_all_completed", self, '_on_tween_complete', [tween, crumb], CONNECT_ONESHOT)


func _on_tween_complete(tween:Tween, crumb:Crumb):
	crumb.on_ground = true
	tween.queue_free()


func reduce_bird_count():
	bird_count -= 1
	if bird_count == 0:
		difficulty_level += 1
		spawn_wave()


func spawn_wave():
	for _x in difficulty_level*3:
		bird_count += 1
		var bird:Bird = _Bird.instance()
		var _error = bird.connect("game_over", self, "game_over")
		var _error2 = bird.connect("fed", self, "reduce_bird_count")
		_birdspawnlocation.offset = randi()
		bird.position = _birdspawnlocation.position
		add_child(bird)



func game_over():
	print("Game Over")
