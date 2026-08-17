class_name IdleState
extends State

@onready var walk: State = $"../Walk"


func enter() -> void:
	player.update_animation("idle")


func process(_delta: float) -> State:
	if player.direction != Vector2.ZERO:
		return walk
	player.velocity = Vector2.ZERO
	return self