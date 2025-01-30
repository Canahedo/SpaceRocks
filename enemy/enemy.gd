class_name Enemy
extends Area2D

enum {LARGE, SMALL}
enum EnemyState {PATROL, HUNT, EVADE}

const SPEED: int = 200

# Public
var size: int = LARGE
var direction: Vector2

# Private
var points: int
var state: EnemyState = EnemyState.PATROL

@onready var gun: Gun = $Gun


func _ready() -> void:
	if size == LARGE:
		gun.bullet_size = 1
		self.scale = Vector2(1, 1)
		points = 8
	else:
		self.scale = Vector2(.5, .5)
		points = 40


func _physics_process(delta: float) -> void:
	global_position += SPEED * direction * delta
	if position.x < -50.0 or position.x > 1970:
		queue_free()



func _destroy() -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area is Bullet and area.shooter_is_player:
		Globals.TARGET_DESTROYED.emit(points)
	if not area is Enemy:
		self._destroy()


func _on_body_entered(body: CharacterBody2D) -> void:
	Globals.TARGET_DESTROYED.emit(points)
	body.destroy()
	self._destroy()
