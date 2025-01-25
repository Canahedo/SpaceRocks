class_name UI
extends Control


@onready var score_label: Label = $ScoreLabel


var paused: bool = false

func _ready():
	Globals.PLAYER_KILLED.connect(_on_life_lost)

func toggle_pause() -> void:
	if not paused:
		Engine.time_scale = 0
	else:
		Engine.time_scale = 1
	paused = !paused

func _on_life_lost():
	print("Player Died")
	pass

"""
on boot, show start screen with option to play or quit
on play, show score and lives, and wait for pause or game over
on pause, show option to resume or quit to start menu
on game over, show option to restart or close game
"""
