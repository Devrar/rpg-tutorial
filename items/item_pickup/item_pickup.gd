@tool
class_name ItemPickup
extends Node2D

@export var item_data: ItemData: set = _set_item_data

@onready var area_2d: Area2D = $Area2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D


func _ready() -> void:
	_update_texture()
	if Engine.is_editor_hint():
		return


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		if item_data:
			if GlobalPlayerManager.INVENTORY_DATA.add_item(item_data) == true:
				item_pick_up()


func item_pick_up() -> void:
	audio_stream_player_2d.play()
	visible = false
	await audio_stream_player_2d.finished
	queue_free()


func _set_item_data(value: ItemData) -> void:
	item_data = value
	_update_texture()


func _update_texture() -> void:
	if item_data and sprite_2d:
		sprite_2d.texture = item_data.texture