class_name Player
extends CharacterBody2D

signal direction_changed(new_direction: Vector2)
signal player_damaged(hurtbox: Hurtbox)

var cardinal_direction: Vector2 = Vector2.DOWN
var direction: Vector2 = Vector2.ZERO
var invulnerable: bool = false
var hp: int = 6
var max_hp: int = 6

const DIR_4 = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var effect_animation_player: AnimationPlayer = $EffectAnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var state_machine: PlayerStateMachine = $PlayerStateMachine
@onready var hitbox: Hitbox = $Hitbox
@onready var audio: AudioStreamPlayer2D = $Audio/AudioStreamPlayer2D


func _ready() -> void:
	GlobalPlayerManager.player = self
	state_machine.initialize(self)
	hitbox.damage_taken.connect(_take_damage)
	update_hp(99)


func _process(_delta: float) -> void:
	direction = Vector2(
			Input.get_axis("left", "right"),
			Input.get_axis("up", "down"),
	).normalized()


func _physics_process(_delta: float) -> void:
	move_and_slide()


func update_animation(state: String) -> void:
	animation_player.play(state + "_" + anim_direction())


func set_direction() -> bool:
	if direction == Vector2.ZERO:
		return false

	var direction_id: int = round((direction + cardinal_direction * 0.1).angle() / TAU * DIR_4.size())
	var new_direction = DIR_4[direction_id]
	
	if new_direction == cardinal_direction:
		return false
	cardinal_direction = new_direction
	direction_changed.emit(new_direction)
	sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	return true


func anim_direction() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"


func _take_damage(hurtbox: Hurtbox) -> void:
	if invulnerable:
		return
	update_hp(-hurtbox.damage)

	if hp > 0:
		player_damaged.emit(hurtbox)
	else:
		player_damaged.emit(hurtbox)
		update_hp(99)


func update_hp(delta: int) -> void:
	hp = clampi(hp + delta, 0, max_hp)
	PlayerHud.update_hp(hp, max_hp)


func make_invulnerable(invulnerable_duration: float) -> void:
	invulnerable = true
	hitbox.monitoring = false

	await get_tree().create_timer(invulnerable_duration).timeout

	invulnerable = false
	hitbox.monitoring = true