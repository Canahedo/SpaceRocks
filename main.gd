extends Node2D

# Node References
@onready var rock_scene: PackedScene = preload("res://rock/rock.tscn")
@onready var screen_size: Vector2 = get_viewport_rect().size


# Variables
var rng: RandomNumberGenerator = RandomNumberGenerator.new()


# Configuration
var rocks_to_spawn: int = 4


func _ready() -> void:
	for i in range(rocks_to_spawn):
		spawn_rock()


func _physics_process(_delta: float) -> void:
	# Screenwrap
	for object in get_children():
		object.position.x = wrapf(object.position.x, 0.0, screen_size.x)
		object.position.y = wrapf(object.position.y, 0.0, screen_size.y)


func spawn_rock() -> void:
	var rock: Rock = rock_scene.instantiate()

	# Spawn all large rocks against a wall
	var wall: int = rng.randi_range(0, 3)
	match wall:
		0:
			rock.position.y = 0
			rock.position.x = rng.randi_range(0, 1920)
		1:
			rock.position.x = 1920
			rock.position.y = rng.randi_range(0, 1080)
		2:
			rock.position.y = 1080
			rock.position.x = rng.randi_range(0, 1920)
		3:
			rock.position.x = 0
			rock.position.y = rng.randi_range(0, 1080)
	rock.initial_direction()
	add_child(rock)
