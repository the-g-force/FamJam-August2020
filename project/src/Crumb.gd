tool
class_name Crumb
extends Node2D

# Indicates if this crumb is in the air or on the ground
var on_ground := true
var color : Color

export var lifetime_variance = .5

onready var _radius = $CollisionShape2D.shape.radius


func _ready():
	randomize()
	var rando = randi()%3
	color = Color.burlywood if rando == 0 else Color.black if rando == 1 else Color.white
	$LifetimeTimer.wait_time += rand_range(-lifetime_variance, lifetime_variance)
	$LifetimeTimer.start()
	update()


func _draw():
	draw_circle(Vector2.ZERO, 1, color)


func _on_LifetimeTimer_timeout():
	queue_free()	
