class_name Hitbox
extends Area2D

signal damage_taken(damage: int)


func take_damage(damage: int) -> void:
	print("Hitbox took damage: ", damage)
	damage_taken.emit(damage)