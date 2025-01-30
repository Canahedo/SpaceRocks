class_name Bullet
extends Area2D

const SPEED: float = 700.0
const LIFESPAN: float = 1.5

#Public
var size: int # Should be either 0 or 1
var direction: Vector2
var shooter_is_player: bool

@onready var lifespan_timer: Timer = $Lifespan
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	lifespan_timer.start(LIFESPAN)
	sprite.frame = size
	hitbox.shape.radius = size + 3


func _physics_process(delta: float) -> void:
	global_position += SPEED * direction * delta


func _on_lifespan_timeout() -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	queue_free()


func _on_body_entered(body: CharacterBody2D) -> void:
	if not shooter_is_player:
		body.destroy()
		queue_free()
