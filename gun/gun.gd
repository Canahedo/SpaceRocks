class_name Gun
extends Node2D

enum {SMALL, LARGE}

const COOLDOWN: float = .1
const RELOAD: float = .5

# Public
var bullet_size: int = SMALL

# Private
var can_fire: bool = true
var ammo: int = 4

@onready var bullet_scene: PackedScene = preload("res://bullet/bullet.tscn")
@onready var cooldown_timer: Timer = $Cooldown
@onready var shooter = get_parent()

func fire(direction: Vector2, burst: bool = false) -> void:
	if not can_fire:
		return
	_create_bullet(direction)
	can_fire = false
	cooldown_timer.start(COOLDOWN)
	if burst:
		ammo -= 1
		if ammo <= 0:
			ammo = 4
			cooldown_timer.start(RELOAD)
	else:
		ammo = 4


func _create_bullet(direction: Vector2):
	# Create bullet, set specifics, and add to tree
	var bullet: Bullet = bullet_scene.instantiate()
	bullet.size = bullet_size
	bullet.global_position = self.global_position
	bullet.direction = direction
	bullet.shooter_is_player = shooter is Player
	shooter.add_sibling(bullet)


func _on_cooldown_timeout() -> void:
	can_fire = true
