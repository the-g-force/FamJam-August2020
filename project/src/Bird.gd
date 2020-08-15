class_name Bird
extends KinematicBody2D

enum State {EATING, WALKING, FLYING}
export var speed : int = 25

onready var bird_color = $AnimatedSprite

var target
var state = State.WALKING
var crumbs_eaten := 0
var color : String
var middle_of_screen : Vector2
var destination : Vector2

signal game_over
signal fed

func _ready():
	randomize()
	middle_of_screen = get_viewport_rect().size/2
	color = str(randi()%3)


func _process(delta:float):
	bird_color.play(color+str(crumbs_eaten))
	if state == State.WALKING:
		destination = middle_of_screen
		var crumbs = $Sensor.get_overlapping_areas()
		for crumb in crumbs:
			if crumb is Crumb:
				if crumb.on_ground:
					destination = crumb.get_global_position()
					target = crumb
					break
		var direction = (destination - position).normalized()
		rotation = direction.angle()
		if (destination - position).length_squared() < 5:
			if target != null:
				target.queue_free()
				target = null
				state = State.EATING
				var eating :AudioStreamPlayer2D = get_node("Eating" + str(randi()%2))
				eating.play()
				yield(get_tree().create_timer(0.5), "timeout")
				crumbs_eaten += 1
				speed -= 5
				if crumbs_eaten < 3:
					state = State.WALKING
				else:
					state = State.FLYING
					speed = 100
					emit_signal("fed")
			if destination == middle_of_screen:
				emit_signal("game_over")
		var velocity = direction*speed
		var _error = move_and_collide(velocity*delta)
	if state == State.FLYING:
		var dir = (position - middle_of_screen).normalized()
		var velocity = dir*speed
		rotation = dir.angle()
		var _error = move_and_collide(velocity*delta)
		if not get_viewport_rect().has_point(position):
			queue_free()
	update()
