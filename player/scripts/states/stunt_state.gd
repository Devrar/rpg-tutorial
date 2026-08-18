class_name StuntState
extends State

@export var knockback_speed: float = 200.0
@export var decelerate_speed: float = 10.0
@export var invulnerable_duration: float = 1.0

var hurtbox: Hurtbox
var direction: Vector2
var next_state: State = null

@onready var idle: State = $"../Idle"


func init() -> void:
	player.player_damaged.connect(_player_damaged)


func enter() -> void:
	player.effect_animation_player.play("damaged")
	player.animation_player.animation_finished.connect(_animation_finished)

	direction = player.global_position.direction_to(hurtbox.global_position)
	player.velocity = direction * (-knockback_speed)
	player.set_direction()
	player.update_animation("stun")

	player.make_invulnerable(invulnerable_duration)


func exit() -> void:
	next_state = null
	player.animation_player.animation_finished.disconnect(_animation_finished)


func process(delta: float) -> State:
	player.velocity -= player.velocity * decelerate_speed * delta
	return next_state


func _player_damaged(_hurtbox: Hurtbox) -> void:
	hurtbox = _hurtbox
	state_machine.change_state(self)


func _animation_finished(_a: String) -> void:
	next_state = idle