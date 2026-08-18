class_name AttackState
extends State

var attacking: bool = false

@export var attack_sound: AudioStream
@export_range(1, 20, 0.5) var decelerate_speed: float = 5.0

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var attack_animation_player: AnimationPlayer = $"../../Sprite2D/AttackEffectSprite/AnimationPlayer"
@onready var walk: State = $"../Walk"
@onready var idle: State = $"../Idle"
@onready var audio: AudioStreamPlayer2D = $"../../Audio/AudioStreamPlayer2D"


func enter() -> void:
	attacking = true
	player.update_animation("attack")
	attack_animation_player.play("attack_" + player.anim_direction())
	animation_player.animation_finished.connect(end_attack)

	audio.stream = attack_sound
	audio.pitch_scale = randf_range(0.9, 1.1)
	audio.play()


func exit() -> void:
	animation_player.animation_finished.disconnect(end_attack)
	attacking = false


func process(delta: float) -> State:
	player.velocity -= player.velocity * decelerate_speed * delta

	if attacking == false:
		if player.direction == Vector2.ZERO:
			return idle
		else:
			return walk
	return self


func end_attack(_anim_name: String) -> void:
	attacking = false
