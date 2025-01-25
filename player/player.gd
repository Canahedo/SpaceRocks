class_name Player
extends CharacterBody2D


# Node References
@onready var gun: Gun = $Gun
@onready var hyperdrive_timer: Timer = $HyperdriveCooldown


class PlayerActions:
	var turn_direction: float
	var is_accelerating: bool
	var is_firing: bool
	var is_holding_fire: bool
	var is_hyperdrive: bool


# Configurations
var rotation_speed: float = 5.0
var accel: float = 1000.0
var friction: float = 100.0
var max_speed: float = 350.0
var hold_fire_counter: float = 0.0
var hold_time: float = 2.0
var can_hyperdrive: bool = true
var hyperdrive_cooldown: float = 5.0


func _physics_process(delta: float) -> void:
	var player_input: PlayerActions = get_input(delta)
	player_movement(delta, player_input)
	if player_input.is_firing:
		gun.fire(self.transform.x, player_input.is_holding_fire)


func get_input(delta: float) -> PlayerActions:
	var input: PlayerActions = PlayerActions.new()
	input.turn_direction = Input.get_axis("left", "right")
	input.is_accelerating = Input.is_action_pressed("up")
	input.is_hyperdrive = Input.is_action_pressed("secondary fire")

	if hold_fire_counter >= hold_time:
		input.is_holding_fire = true
	if Input.is_action_pressed("primary fire"):
		input.is_firing = true
		hold_fire_counter += delta
	else:
		hold_fire_counter = 0.0

	return input


func player_movement(delta: float, actions: PlayerActions) -> void:

	if actions.is_hyperdrive and can_hyperdrive:
		self.position = Vector2(randi_range(0, 1920), randi_range(0, 1080))
		can_hyperdrive = false
		hyperdrive_timer.start(hyperdrive_cooldown)

	self.rotation += rotation_speed * actions.turn_direction * delta

	if actions.is_accelerating:
		self.velocity += (self.transform.x * accel * delta)
		self.velocity = self.velocity.limit_length(max_speed)
	elif self.velocity.length() > (friction * delta):
		self.velocity -= (velocity.normalized() * friction * delta)
	else:
		self.velocity = Vector2.ZERO

	var _collided: bool = move_and_slide()


func _on_hyperdrive_cooldown_timeout() -> void:
	can_hyperdrive = true


func destroy() -> void:
	queue_free()
