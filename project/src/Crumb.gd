tool
extends Node2D

onready var _radius = $CollisionShape2D.shape.radius

# Called when the node enters the scene tree for the first time.
func _ready():
	update()


func _draw():
	draw_circle(Vector2.ZERO, _radius, Color.yellow)
