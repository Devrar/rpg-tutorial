class_name Boomerang
extends Node2D

enum State {
	INACTIVE,
	THROW,
	RETURN,
}

@export var acceleration: float = 500.0
@export var max_speed: float = 400.0
@export var catch_audio: AudioStream

var player: Player
var direction: Vector2
var speed: float = 0
var state: Boomerang.State

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D


func _ready() -> void:
	visible = false
	state = State.INACTIVE
	player = GlobalPlayerManager.player


func _physics_process(delta: float) -> void:
	if state == State.THROW:
		speed -= acceleration * delta
		if speed <= 0:
			state = State.RETURN
		else:
			position += direction * speed * delta
	elif state == State.RETURN:
		direction = global_position.direction_to(player.global_position)
		speed += acceleration * delta
		position += direction * speed * delta
		if global_position.distance_to(player.global_position) <= 10:
			GlobalPlayerManager.play_audio(catch_audio)
			queue_free()
	
	var speed_ratio = speed / max_speed
	audio.pitch_scale = speed_ratio * 0.75 + 0.75

	animation_player.speed_scale = 1 + speed_ratio * 0.5


func throw(throw_direction: Vector2) -> void:
	direction = throw_direction
	speed = max_speed
	state = State.THROW
	animation_player.play("boomerang")
	GlobalPlayerManager.play_audio(catch_audio)
	visible = true