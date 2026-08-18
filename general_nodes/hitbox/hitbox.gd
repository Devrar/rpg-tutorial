class_name Hitbox
extends Area2D

signal damage_taken(hurtbox: Hurtbox)


func take_damage(hurtbox: Hurtbox) -> void:
	print("Hitbox took damage: ", hurtbox.damage)
	damage_taken.emit(hurtbox)