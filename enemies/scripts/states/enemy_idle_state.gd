class_name EnemyStateIdle
extends EnemyState

@export var anim_name: String = "idle"

@export_category("AI")
@export var state_min_duration: float = 0.5
@export var state_max_duration: float = 1.5
@export var next_state: EnemyState

var timer: float = 0.0


func enter() -> void:
	enemy.velocity = Vector2.ZERO
	timer = randf_range(state_min_duration, state_max_duration)
	enemy.update_animation(anim_name)


func process(delta: float) -> EnemyState:
	timer -= delta
	if timer <= 0:
		return next_state
	
	return self
