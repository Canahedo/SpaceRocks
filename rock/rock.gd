class_name Rock
extends Area2D

enum {LARGE, MEDIUM, SMALL}

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: CollisionShape2D = $CollisionShape2D

@onready var rock_size: int = LARGE
var radius: int

var direction: Vector2
var speed: float

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _ready() -> void:
	sprite.frame = rng.randi_range(0,2)
	set_rotation_degrees(rng.randi_range(-360,360))
	match rock_size:
		LARGE:
			self.scale = Vector2(1, 1)
			radius = 60
			speed = 1
		MEDIUM:
			self.scale = Vector2(.5, .5)
			radius = 30
			speed = 1.5
		SMALL:
			self.scale = Vector2(.25, .25)
			radius = 20
			speed = 2

	hitbox.shape.radius = radius

func _physics_process(delta: float) -> void:
	global_position += speed * direction * delta


func initial_direction() -> void:
	direction = Vector2(rng.randi_range(-360, 360), rng.randi_range(-360, 360))

func destroy() -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	if not area is Rock:
		destroy()

func _on_body_entered(body: Node2D) -> void:
	body.destroy()
