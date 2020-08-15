extends KinematicBody2D

export var speed : int = 200

var destination : Vector2

func _ready():
	destination = get_viewport_rect().size/2


func _process(delta:float):
	var crumbs = $Sensor.get_overlapping_areas()
	for crumb in crumbs:
		if crumb.on_ground:
			destination = crumb.get_global_position()
			break
	var direction = (destination - position).normalized()
	var velocity = direction*speed
	var _error = move_and_collide(velocity*delta)
	update()


func _draw():
	draw_circle(Vector2.ZERO, 10, Color.azure)

