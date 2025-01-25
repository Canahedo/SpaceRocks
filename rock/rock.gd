class_name Rock
extends Area2D

enum {SMALL, MEDIUM, LARGE}

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: CollisionShape2D = $CollisionShape2D
@onready var rock_scene: PackedScene = preload("res://rock/rock.tscn")

@onready var rock_size: int

var direction: Vector2
var speed = 200
var rock_splits = 2 # How many smaller rocks spawn when a rock is destroyed

var rng: RandomNumberGenerator = RandomNumberGenerator.new()


func _ready() -> void:
	sprite.frame = rng.randi_range(0,2)
	set_rotation_degrees(rng.randi_range(-360,360))
	match rock_size:
		SMALL:
			self.scale = Vector2(.25, .25)
		MEDIUM:
			self.scale = Vector2(.5, .5)
		LARGE:
			self.scale = Vector2(1, 1)



func _physics_process(delta: float) -> void:
	global_position += speed * direction * delta


func trajectory(parent_dir: Vector2 = Vector2.ZERO) -> void:
	if parent_dir == Vector2.ZERO:
		direction = Vector2(rng.randi_range(-360, 360), rng.randi_range(-360, 360)).normalized()
	else:
		var spread: float = PI / 2
		var change = randf_range(-spread, +spread)
		print(change)
		direction = parent_dir.rotated(change)
	print(direction)


func destroy() -> void:
	if rock_size != 0:
		for i in range(rock_splits):
			var rock: Rock = rock_scene.instantiate()
			rock.rock_size = self.rock_size - 1
			rock.trajectory(self.direction)
			rock.global_position = self.global_position
			call_deferred("add_sibling", rock)
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	if not area is Rock and area.has_method("destroy"):
		area.destroy()


func _on_body_entered(body: Node2D) -> void:
	body.destroy()
