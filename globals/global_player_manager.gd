extends Node

var player: Player
var player_spawned: bool = false

const PLAYER = preload("res://player/player.tscn")


func _ready() -> void:
	add_player_instance()
	await get_tree().create_timer(0.5).timeout
	player_spawned = true


func add_player_instance() -> void:
	player = PLAYER.instantiate()
	add_child(player)


func set_player_position(new_position: Vector2) -> void:
	player.global_position = new_position