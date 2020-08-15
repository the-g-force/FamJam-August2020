extends Node2D

const _Crumb = preload("res://src/Crumb.tscn")
const _Bird = preload("res://src/Bird.tscn")

# How long is the crumb "in the air"?
export var toss_duration := 1.1
# How many crumbs to load up per second
export var crumbs_load_rate : float = 0.5
# How wide does a cluster of crumbs spread?
export var crumbs_spread_radius : float = 20
# How far from the center does a bird spawn?
export var spawn_radius : float = 350

var _pressed := false
var difficulty_level := 1
var bird_count := 0
var _seconds : float = 0
var gameover := false

onready var _crumbs = $Crumbs
onready var _feeding : AudioStreamPlayer = $Feeding
onready var _crumbs_label = $Control/Label
onready var _waves_completed_label : Label = $EndGameMessage/WavesCompleted
onready var _game_over_ui : Node = $EndGameMessage
onready var _crumbs_progress : ProgressBar = $Control/ProgressBar
onready var _thrower : AnimationPlayer = $guy/AnimationPlayer
onready var _guy :Sprite = $guy
# The node whose location the crumbs spawn from
onready var _hand : Node2D = $guy/Hand
onready var _wave_label : Label = $WaveLabel
onready var _birds_node = $Birds

func _ready():
	spawn_wave()


func _process(delta):
	if _pressed:
		_seconds += delta
		_crumbs_label.text = str(_crumbs_to_throw())
		_crumbs_progress.value = fmod(_seconds, crumbs_load_rate) / crumbs_load_rate
	else:
		_crumbs_label.text = ''
		_crumbs_progress.value = 0


func _crumbs_to_throw() -> float:
	return floor(_seconds / crumbs_load_rate)


func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.is_pressed():
			if not gameover:
				_pressed = true
				_seconds = 0
		elif not gameover:
			_pressed = false
			_throw_crumbs()


func _throw_crumbs():
	_thrower.play("Throw")
	_feeding.play()
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
	_wave_label.text = "Wave " + str(difficulty_level)
	$AnimationPlayer.play("WaveLabelPulse")
	for _x in 2+difficulty_level*2:
		bird_count += 1
		var bird:Bird = _Bird.instance()
		var _error = bird.connect("game_over", self, "game_over")
		var _error2 = bird.connect("fed", self, "reduce_bird_count")
		bird.position = Vector2(300,300) + Vector2(spawn_radius,0).rotated(randf()*PI*2)
		_birds_node.add_child(bird)



func game_over():
	_game_over_ui.show()
	_waves_completed_label.text = "You fed " + str(difficulty_level-1) + \
	(" flock!" if difficulty_level-1 == 1 else " flocks!")
	gameover = true


func _on_MainMenuButton_pressed():
	var _ignored = get_tree().change_scene("res://src/screens/MainMenu.tscn")
