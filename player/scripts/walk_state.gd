class_name WalkState
extends State

@export var move_speed: float = 100.0

@onready var idle: State = $"../Idle"
@onready var attack: State = $"../Attack"


func enter() -> void:
	player.update_animation("walk")


func process(_delta: float) -> State:
	if player.direction == Vector2.ZERO:
		return idle
	
	player.velocity = player.direction * move_speed

	if player.set_direction():
		player.update_animation("walk")

	return self


func handle_input(event: InputEvent) -> State:
	if event.is_action_pressed("attack"):
		return attack
	return self