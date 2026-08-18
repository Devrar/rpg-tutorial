class_name EnemyStateDestroy
extends EnemyState

@export var anim_name: String = "destroy"
@export var knockback_speed: float = 200.0
@export var decelerate_speed: float = 10.0

@export_category("AI")

var direction: Vector2
var damage_position: Vector2


func init() -> void:
	enemy.enemy_destroyed.connect(_on_enemy_destroyed)


func enter() -> void:
	enemy.invulnerable = true

	direction = enemy.global_position.direction_to(damage_position)

	enemy.set_direction(direction)
	enemy.velocity = direction * (-knockback_speed)

	enemy.update_animation(anim_name)
	enemy.animation_player.animation_finished.connect(_on_animation_finished)


func process(delta: float) -> EnemyState:
	enemy.velocity -= enemy.velocity * decelerate_speed * delta
	return self


func _on_enemy_destroyed(hurtbox: Hurtbox) -> void:
	damage_position = hurtbox.global_position
	state_machine.change_state(self)


func _on_animation_finished(_a: String) -> void:
	enemy.queue_free()