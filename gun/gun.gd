class_name Gun
extends Node2D


enum {SMALL, LARGE}


# Node References
@onready var bullet_scene: PackedScene = preload("res://bullet/bullet.tscn")
@onready var reload_timer: Timer = $Reload
@onready var cooldown_timer: Timer = $Cooldown
@onready var shooter = get_parent()


# Variables
var can_fire: bool = true
var bullet_size: int = SMALL


# Configuration
var shots_remaining: int = 4
var reload_cd: float = .25
var cd_long: float = .1
var cd_short: float = .075


func fire(direction: Vector2, holding_fire: bool = false) -> void:
	if not can_fire or shots_remaining <= 0:
		return

	# Create bullet, set specifics, and add to tree
	var bullet: Bullet = bullet_scene.instantiate()
	bullet.size = bullet_size
	bullet.global_position = self.global_position
	bullet.direction = direction
	bullet.shooter = shooter
	shooter.add_sibling(bullet)

	# Cooldown and reload
	shots_remaining -= 1
	if reload_timer.is_stopped():
		reload_timer.start(reload_cd)
	can_fire = false
	if shots_remaining == 0 and holding_fire:
		cooldown_timer.start(reload_cd)
	elif not holding_fire:
		cooldown_timer.start(cd_long)
	else:
		cooldown_timer.start(cd_short)


func _on_reload_timeout() -> void:
	shots_remaining = clampi(shots_remaining + 1, 0, 4)


func _on_cooldown_timeout() -> void:
	can_fire = true
