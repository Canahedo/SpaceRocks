class_name Gun
extends Node2D


enum {SMALL, LARGE}


# Node References
@onready var bullet_scene: PackedScene = preload("res://bullet/bullet.tscn")
@onready var cooldown_timer: Timer = $Cooldown
@onready var shooter = get_parent()


# Variables
var can_fire: bool = true
var bullet_size: int = SMALL


# Configuration
var cooldown: float = .1


func fire(direction: Vector2) -> void:
	if not can_fire:
		return

	# Create bullet, set specifics, and add to tree
	var bullet: Bullet = bullet_scene.instantiate()
	bullet.size = bullet_size
	bullet.global_position = self.global_position
	bullet.direction = direction
	bullet.shooter = shooter
	shooter.add_sibling(bullet)

	# Cooldown
	can_fire = false
	cooldown_timer.start(cooldown)


func _on_cooldown_timeout() -> void:
	can_fire = true
