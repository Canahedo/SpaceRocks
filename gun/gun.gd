class_name Gun
extends Node2D


enum {SMALL, LARGE}


# Node References
@onready var bullet_scene: PackedScene = preload("res://bullet/bullet.tscn")
@onready var cooldown_timer: Timer = $Cooldown
@onready var shooter = get_parent()
@onready var shooter_is_player: bool = shooter is Player



# Variables
var can_fire: bool = true
var bullet_size: int = SMALL


# Configuration
var cooldown: float = .1
var burst_reload: float = .5
var burst_ammo: int = 4

func fire_type(direction: Vector2, burst: bool = false) -> void:
	if not can_fire:
		return
	shoot(direction)
	can_fire = false

	if burst:
		burst_ammo -= 1
		if burst_ammo > 0:
			cooldown_timer.start(cooldown)
		else:
			cooldown_timer.start(burst_reload)
			burst_ammo = 4

	else:
		cooldown_timer.start(cooldown)
		burst_ammo = 4


func shoot(direction: Vector2):
	# Create bullet, set specifics, and add to tree
	var bullet: Bullet = bullet_scene.instantiate()
	bullet.size = bullet_size
	bullet.global_position = self.global_position
	bullet.direction = direction
	bullet.shooter_is_player = shooter_is_player
	shooter.add_sibling(bullet)

func _on_cooldown_timeout() -> void:
	can_fire = true
