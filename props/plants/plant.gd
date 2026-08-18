class_name Plant
extends Node2D


func _ready() -> void:
	($Hitbox as Hitbox).damage_taken.connect(take_damage)


func take_damage(_hurtbox: Hurtbox) -> void:
	queue_free()