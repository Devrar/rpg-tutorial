@tool
class_name LevelTransition
extends Area2D

enum Side {
	LEFT,
	RIGHT,
	TOP,
	BOTTOM,
}

@export_file("*.tscn") var level
@export var target_transition_area: String = "LevelTransition"
@export var center_player: bool = false

@export_category("Collision Area Settings")
@export_range(1, 12, 1, "or_greater") var size: int = 2:
	set(value):
		size = value
		_update_area()
@export var side: LevelTransition.Side = Side.LEFT:
	set(value):
		side = value
		_update_area()
@export var snap_to_grid: bool = false:
	set(value):
		if value:
			_snap_to_grid()

@onready var collision_shape: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	_update_area()
	if Engine.is_editor_hint():
		return

	monitoring = false
	_place_player()

	await GlobalLevelManager.level_loaded

	monitoring = true
	body_entered.connect(_player_entered)


func _update_area() -> void:
	var new_rect: Vector2 = Vector2(32, 32)
	var new_position: Vector2 = Vector2.ZERO

	if side == Side.TOP:
		new_rect.x *= size
		new_position.y -= 16
	elif side == Side.BOTTOM:
		new_rect.x *= size
		new_position.y += 16
	elif side == Side.LEFT:
		new_rect.y *= size
		new_position.x -= 16
	elif side == Side.RIGHT:
		new_rect.y *= size
		new_position.x += 16
	
	if collision_shape == null:
		collision_shape = get_node("CollisionShape2D")
	

	collision_shape.shape.size = new_rect
	collision_shape.position = new_position


func _snap_to_grid() -> void:
	position.x = round(position.x / 16) * 16
	position.y = round(position.y / 16) * 16


func _player_entered(_player: Node2D) -> void:
	GlobalLevelManager.load_new_level(level, target_transition_area, get_offset())


func _place_player() -> void:
	if name != GlobalLevelManager.target_transition:
		return
	
	GlobalPlayerManager.set_player_position(global_position + GlobalLevelManager.position_offset)


func get_offset() -> Vector2:
	var offset: Vector2 = Vector2.ZERO
	var player_position = GlobalPlayerManager.player.global_position

	if side == Side.LEFT or side == Side.RIGHT:
		if center_player:
			offset.y = 0
		else:
			offset.y = player_position.y - global_position.y
		offset.x = 16
		if side == Side.LEFT:
			offset.x *= -1
	else:
		if center_player:
			offset.x = 0
		else:
			offset.x = player_position.x - global_position.x
		offset.y = 16
		if side == Side.TOP:
			offset.y *= -1


	return offset