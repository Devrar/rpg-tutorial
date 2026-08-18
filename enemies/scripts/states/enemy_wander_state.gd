class_name EnemyStateWander
extends EnemyState

@export var anim_name: String = "walk"
@export var wander_speed: float = 20.0

@export_category("AI")
@export var state_animation_duration: float = 0.5
@export var state_min_cycles: int = 1
@export var state_max_cycles: int = 3
@export var next_state: EnemyState

var timer: float = 0.0
var direction: Vector2


func enter() -> void:
	timer = randi_range(state_min_cycles, state_max_cycles) * state_animation_duration

	direction = enemy.DIR_4[randi_range(0, 3)]
	enemy.velocity = direction * wander_speed
	enemy.set_direction(direction)
	enemy.update_animation(anim_name)


func process(delta: float) -> EnemyState:
	timer -= delta
	if timer <= 0:
		return next_state
	return self
