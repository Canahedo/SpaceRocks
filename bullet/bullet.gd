class_name Bullet
extends Area2D


# Node References
@onready var lifespan_timer: Timer = $Lifespan
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: CollisionShape2D = $CollisionShape2D


# Variables
var size: int
var direction: Vector2


# Configuration
const SPEED: float = 700.0
const LIFESPAN: float = 2.0


func _ready() -> void:
	sprite.frame = size
	lifespan_timer.start(LIFESPAN)
	hitbox.shape.radius = size + 3


func _physics_process(delta: float) -> void:
	global_position += SPEED * direction * delta


func _on_lifespan_timeout() -> void:
	queue_free()


func destroy() -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	area.destroy()
