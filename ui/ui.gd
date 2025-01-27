class_name UI
extends CanvasLayer


@onready var score_label: Label = $UI/ScoreLabel
@onready var lives_container: HBoxContainer = $UI/LivesContainer
@onready var main = get_parent()
@onready var start_menu: VBoxContainer = $UI/StartMenu
@onready var pause_menu: VBoxContainer = $UI/PauseMenu
@onready var end_menu: VBoxContainer = $UI/EndMenu


var score: int = 0
var paused: bool = false
var end_text: String
var extra_life: int = 10_000


func _ready() -> void:
	pass


func attract() -> void:
	score_label.visible = false
	lives_container.visible = false
	start_menu.visible = true


func toggle_pause() -> void:
	if not paused:
		Engine.time_scale = 0
		pause_menu.visible = true
	else:
		Engine.time_scale = 1
		pause_menu.visible = false
	paused = !paused


func life_lost() -> void:
	if lives_container.get_child_count() == 1:
		lives_container.visible = false
	else:
		lives_container.get_child(-1).queue_free()


func life_gain() -> void:
	main.lives_remaining += 1
	var extra_ship = lives_container.get_child(0).duplicate()
	lives_container.add_child(extra_ship)

func game_over() -> void:
	end_menu.visible = true


func increase_score(size):
	score += size * 25
	score_label.text = str(score)
	if score >= extra_life:
		extra_life += 10_000
		life_gain()


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_start_button_pressed() -> void:
	score_label.visible = true
	lives_container.visible = true
	start_menu.visible = false
	end_menu.visible = false
	main.setup_game()


func _on_resume_button_pressed() -> void:
	toggle_pause()


func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()
