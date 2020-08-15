extends Area2D

signal touch_complete(seconds)

var _pressed := false
var _seconds : float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if _pressed:
		_seconds += delta
		print('Elapsed: ' + str(_seconds))

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index==BUTTON_LEFT:
		if event.pressed and not _pressed:
			_pressed = true
			_seconds = 0
			print('Pressed is true')
		elif not event.pressed and _pressed:
			_pressed = false
			print('Touch complete')
			emit_signal('touch_complete', _seconds)
		
