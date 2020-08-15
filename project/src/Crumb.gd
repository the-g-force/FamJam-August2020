tool
class_name Crumb
extends Node2D

# Indicates if this crumb is in the air or on the ground
var on_ground := true

onready var _radius = $CollisionShape2D.shape.radius

# Called when the node enters the scene tree for the first time.
func _ready():
	update()


func _draw():
	draw_circle(Vector2.ZERO, _radius, Color.yellow)
