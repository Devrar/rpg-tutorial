class_name Level
extends Node2D


func _ready() -> void:
	y_sort_enabled = true
	GlobalPlayerManager.set_as_parent(self)
	GlobalLevelManager.level_load_started.connect(_free_level)


func _free_level() -> void:
	GlobalPlayerManager.unparent_player(self)
	queue_free()
