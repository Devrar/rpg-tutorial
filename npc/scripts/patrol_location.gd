@tool
class_name PatrolLocation
extends Node2D

signal transform_changed

@export var wait_time: float = 0.0: set = _set_wait_time

var target_position: Vector2 = Vector2.ZERO


func _enter_tree() -> void:
	set_notify_transform(true)


func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSFORM_CHANGED:
		transform_changed.emit()


func _ready() -> void:
	target_position = global_position
	_update_wait_time_label()

	if Engine.is_editor_hint():
		return
	
	$Sprite2D.queue_free()


func update_label(s: String) -> void:
	$Sprite2D/Label.text = s


func update_line(next_location: Vector2) -> void:
	var line: Line2D = $Sprite2D/Line2D
	var new_points: Array[Vector2] = [line.points[0], next_location - position]
	line.points = new_points


func _set_wait_time(value: float) -> void:
	wait_time = value
	_update_wait_time_label()


func _update_wait_time_label() -> void:
	if not is_node_ready():
		await ready
	if Engine.is_editor_hint():
		$Sprite2D/Label2.text = "wait: %0.2fs" % wait_time
