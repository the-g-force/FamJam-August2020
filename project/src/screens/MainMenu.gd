extends Control

const _GameplayLevel : PackedScene = preload("res://src/GameplayLevel.tscn")

onready var _fullscreen_toggle = $VBoxContainer/HBoxContainer/FullscreenToggle


func _ready():
	Jukebox.play_title_theme()
	_fullscreen_toggle.pressed = OS.window_fullscreen
	

func _on_PlayButton_pressed():
	Jukebox.play_game_theme()
	var _ignored_result = get_tree().change_scene_to(_GameplayLevel)


func _on_FullscreenToggle_toggled(button_pressed):
	OS.window_fullscreen = button_pressed
