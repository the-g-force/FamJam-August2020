extends AudioStreamPlayer

const _SONGS = {
	
}

var title_theme = preload("res://assets/music/gameplay3.ogg")
var game_theme = preload("res://assets/music/birds.ogg")

func play_title_theme():
	stream = title_theme
	play()
	
func play_game_theme():
	stream = game_theme
	play()
