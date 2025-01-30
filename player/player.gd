class_name Player
extends CharacterBody2D

const ROTATION_SPEED: float = 4.0
const ACCEL: float = 500.0
const FRICTION: float = 100.0
const MAX_SPEED: float = 350.0
const HYPERDRIVE_COOLDOWN: float = 5.0
const HOLD_THRESHOLD: float = .5

# Private
var can_hyperdrive: bool = true
var hold_counter: float = 0.0

@onready var gun: Gun = $Gun
@onready var hyperdrive_timer: Timer = $HyperdriveCooldown
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(delta: float) -> void:
	if Engine.time_scale == 0:
		return
	var player_input: PlayerActions = get_input(delta)
	player_movement(delta, player_input)
	player_animation(player_input.is_accelerating)
	if player_input.fire_type != "none":
		gun.fire(self.transform.x, (player_input.fire_type == "burst"))


func get_input(delta) -> PlayerActions:
	var input: PlayerActions = PlayerActions.new()
	input.turn_direction = Input.get_axis("left", "right")
	input.is_accelerating = Input.is_action_pressed("up")
	input.is_hyperdrive = Input.is_action_pressed("secondary fire")

	if Input.is_action_pressed("primary fire"):
		if Input.is_action_just_pressed("primary fire"):
			input.fire_type = "single"
			hold_counter = 0.0
		elif hold_counter >= HOLD_THRESHOLD:
			input.fire_type = "burst"
		else:
			hold_counter += delta
			input.fire_type = "none"

	return input


func player_movement(delta: float, actions: PlayerActions) -> void:
	if actions.is_hyperdrive and can_hyperdrive:
		self.position = Vector2(randi_range(0, 1920), randi_range(0, 1080))
		can_hyperdrive = false
		hyperdrive_timer.start(HYPERDRIVE_COOLDOWN)
	self.rotation += ROTATION_SPEED * actions.turn_direction * delta

	if actions.is_accelerating:
		self.velocity += (self.transform.x * ACCEL * delta)
		self.velocity = self.velocity.limit_length(MAX_SPEED)
	elif self.velocity.length() > (FRICTION * delta):
		self.velocity -= (velocity.normalized() * FRICTION * delta)
	else:
		self.velocity = Vector2.ZERO

	var _collided: bool = move_and_slide()


func player_animation(is_accelerating) -> void:
	if is_accelerating:
		animation.play("forward")
	else:
		animation.play("default")


func destroy() -> void:
	Globals.PLAYER_KILLED.emit()
	queue_free()


func _on_hyperdrive_cooldown_timeout() -> void:
	can_hyperdrive = true


class PlayerActions:
	var turn_direction: float
	var is_accelerating: bool = false
	var fire_type: String = "none"
	var is_hyperdrive: bool = false
