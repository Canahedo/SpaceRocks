class_name Enemy
extends Area2D


enum {LARGE, SMALL}

@onready var gun: Gun = $Gun



var size: int = LARGE
var points: int
var direction: Vector2
var speed: int = 200


func _ready() -> void:
	if size == LARGE:
		gun.bullet_size = 1

	match size:
		LARGE:
			self.scale = Vector2(1, 1)
			points = 8
		SMALL:
			self.scale = Vector2(.5, .5)
			points = 40

func _physics_process(delta: float) -> void:
	global_position += speed * direction * delta
	if position.x < -50.0 or position.x > 1970:
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area is Bullet and area.shooter_is_player:
		Globals.TARGET_DESTROYED.emit(points)
	if not area is Enemy and area.has_method("destroy"):
		area.destroy()


func destroy() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	body.destroy()
	self.destroy()
