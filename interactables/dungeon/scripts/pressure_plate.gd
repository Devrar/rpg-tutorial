class_name PressurePlate
extends Node2D

const AUDIO_ACTIVATE: AudioStream = preload("res://interactables/dungeon/lever-01.wav")
const AUDIO_DEACTIVATE: AudioStream = preload("res://interactables/dungeon/lever-02.wav")

signal activated
signal deactivated

var bodies: int = 0
var is_active: bool = false
var off_rect: Rect2

@onready var area_2d: Area2D = $Area2D
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	area_2d.body_entered.connect(_on_body_entered)
	area_2d.body_exited.connect(_on_body_exited)
	off_rect = sprite.region_rect


func _on_body_entered(body: Node2D) -> void:
	bodies += 1
	check_is_activated()


func _on_body_exited(body: Node2D) -> void:
	bodies -= 1
	check_is_activated()


func check_is_activated() -> void:
	if bodies > 0 and not is_active:
		is_active = true
		sprite.region_rect.position.x = off_rect.position.x - 32
		play_audio(AUDIO_ACTIVATE)
		activated.emit()
	elif bodies == 0 and is_active:
		is_active = false
		sprite.region_rect.position.x = off_rect.position.x
		play_audio(AUDIO_DEACTIVATE)
		deactivated.emit()


func play_audio(stream: AudioStream) -> void:
	audio.stream = stream
	audio.play()
