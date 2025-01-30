extends Node2D

enum {ATTRACT, PLAY, END}

const INITIAL_ENEMY_DELAY: float = 35.0
const LATER_ENEMY_DELAY: float = 10.0
const RESPAWN_DELAY: float = 1.5

# Private
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var game_state: int = ATTRACT
var lives_remaining: int = 3
var rocks_to_spawn: int = 4

@onready var rock_scene: PackedScene = preload("res://rock/rock.tscn")
@onready var player_scene: PackedScene = preload("res://player/player.tscn")
@onready var enemy_scene: PackedScene = preload("res://enemy/enemy.tscn")
@onready var ui: UI = $UI
@onready var game_objects: Node2D = $GameObjects
@onready var respawn_timer: Timer = $Respawn
@onready var level_up_timer: Timer = $LevelUp
@onready var enemy_delay_timer: Timer = $EnemyDelay
@onready var screen_size: Vector2 = get_viewport_rect().size


func _ready() -> void:
	Globals.PLAYER_KILLED.connect(_on_player_killed)
	Globals.TARGET_DESTROYED.connect(_on_target_destroyed)
	setup_attract()


func setup_attract():
	ui.attract()
	for i in range(3 * rocks_to_spawn):
		spawn_rock(3)
		spawn_rock(2)
		spawn_rock(1)


func setup_game() -> void:
	clear_board()
	spawn_player()
	for i in range(rocks_to_spawn):
		spawn_rock()
	enemy_delay_timer.start(pick_enemy_respawn(true))
	game_state = PLAY


func spawn_player() -> void:
	var player: Player = player_scene.instantiate()
	player.position = Vector2(960, 540)
	player.rotation_degrees = -90
	game_objects.add_child(player)


func _physics_process(_delta: float) -> void:

	if game_state == PLAY:
		if Input.is_action_just_pressed("pause"):
			ui.toggle_pause()
		if get_tree().get_nodes_in_group("target").is_empty() and level_up_timer.is_stopped():
			level_up_timer.start()

	# Screenwrap
	for object in game_objects.get_children():
		object.position.x = wrapf(object.position.x, -60.0, screen_size.x + 60.0)
		object.position.y = wrapf(object.position.y, -60.0, screen_size.y + 60.0)


func pick_enemy_respawn(new_level: bool = false) -> float:
	if new_level:
		var enemy_spawn_variance: float = rng.randf_range(-LATER_ENEMY_DELAY, LATER_ENEMY_DELAY)
		return INITIAL_ENEMY_DELAY + enemy_spawn_variance
	else:
		return rng.randf_range((LATER_ENEMY_DELAY), LATER_ENEMY_DELAY * 2)


func pick_enemy_size():
	var score_tier : float = clampf(ui.score / 1000.0, 0, 4)
	var threshold: float = (score_tier + 1) * 20
	if rng.randi_range(1, 100) > threshold:
		return 0
	else:
		return 1


func spawn_rock(size: int = 1) -> void:
	var rock: Rock = rock_scene.instantiate()
	rock.size = size
	# Spawn all large rocks against a wall
	var wall: int = rng.randi_range(0, 3)
	match wall:
		0:
			rock.position.y = -60
			rock.position.x = rng.randi_range(0, 1920)
		1:
			rock.position.x = 1980
			rock.position.y = rng.randi_range(0, 1080)
		2:
			rock.position.y = 1140
			rock.position.x = rng.randi_range(0, 1920)
		3:
			rock.position.x = -60
			rock.position.y = rng.randi_range(0, 1080)
	rock.trajectory()
	game_objects.add_child(rock)


func spawn_enemy(size: int = 0):
	var enemy: Enemy = enemy_scene.instantiate()
	enemy.size = size

	var wall: int = rng.randi_range(0, 1)
	match wall:
		0:
			enemy.position.x = -50
			enemy.position.y = rng.randi_range(0, 1080)
			enemy.direction = Vector2.RIGHT
		1:
			enemy.position.x = 1970
			enemy.position.y = rng.randi_range(0, 1080)
			enemy.direction = Vector2.LEFT

	game_objects.add_child(enemy)


func clear_board() -> void:
	for object in game_objects.get_children():
		object.queue_free()


func _on_player_killed():
	lives_remaining -= 1
	if lives_remaining < 0:
		ui.game_over()
		game_state = END
	else:
		ui.life_lost()
		respawn_timer.start(RESPAWN_DELAY)


func _on_target_destroyed(size) -> void:
	ui.increase_score(size)


func _on_respawn_timeout() -> void:
	spawn_player()


func _on_level_up_timeout() -> void:
	rocks_to_spawn += 2
	for i in range(rocks_to_spawn):
		spawn_rock()
	enemy_delay_timer.start(pick_enemy_respawn(true))


func _on_enemy_delay_timeout() -> void:
	spawn_enemy(pick_enemy_size())
	enemy_delay_timer.start(pick_enemy_respawn())
