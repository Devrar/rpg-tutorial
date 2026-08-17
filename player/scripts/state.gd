class_name State
extends Node

static var player: Player


func enter() -> void:
	pass


func exit() -> void:
	pass


func process(_delta: float) -> State:
	return null


func physics_process(_delta: float) -> State:
	return null


func handle_input(_event: InputEvent) -> State:
	return null