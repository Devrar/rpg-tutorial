class_name Abilities
extends Node

const BOOMERANG = preload("res://player/boomerang.tscn")

enum Abilities {
	BOOMERANG,
	GRAPPLE,
}

var selected_ability = Abilities.BOOMERANG
var player: Player
var boomerang_instance: Boomerang = null


func _ready() -> void:
	player = GlobalPlayerManager.player


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ability"):
		match selected_ability:
			Abilities.BOOMERANG:
				boomerang_ability()
			_:
				pass


func boomerang_ability() -> void:
	if boomerang_instance:
		return

	boomerang_instance = BOOMERANG.instantiate() as Boomerang
	player.add_sibling(boomerang_instance)
	boomerang_instance.global_position = player.global_position
	var throw_direction = player.direction
	if throw_direction == Vector2.ZERO:
		throw_direction = player.cardinal_direction

	boomerang_instance.throw(throw_direction)
