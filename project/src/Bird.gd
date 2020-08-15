class_name Bird
extends KinematicBody2D

enum State {EATING, WALKING}
export var speed : int = 100

var target
var state = State.WALKING
var crumbs_eaten := 0
var middle_of_screen : Vector2
var destination : Vector2

signal game_over

func _ready():
	middle_of_screen = get_viewport_rect().size/2


func _process(delta:float):
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
		if (destination - position).length_squared() < 5:
			if target != null:
				target.queue_free()
				target = null
				state = State.EATING
				yield(get_tree().create_timer(0.5), "timeout")
				crumbs_eaten += 1
				state = State.WALKING
			if destination == middle_of_screen:
				emit_signal("game_over")
		var velocity = direction*speed
		var _error = move_and_collide(velocity*delta)
		update()


func _draw():
	draw_circle(Vector2.ZERO, 10, Color.azure)

