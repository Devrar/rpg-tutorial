class_name Hurtbox
extends Area2D

@export var damage: int = 1


func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _on_area_entered(area: Area2D) -> void:
	if area is Hitbox:
		var hitbox = area as Hitbox
		hitbox.take_damage(self)