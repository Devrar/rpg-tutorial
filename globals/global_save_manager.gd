extends Node

signal game_loaded
signal game_saved

const SAVE_PATH = "user://"

var current_save: Dictionary = {
	scene_path = "",
	player = {
		hp = 1,
		max_hp = 1,
		pos_x = 0,
		pos_y = 0,
	},
	items = [],
	persistence = [],
	quests = [],
}


func save_game() -> void:
	update_player_data()
	update_scene_path()
	var file := FileAccess.open(SAVE_PATH + "save.sav", FileAccess.WRITE)
	var save_json := JSON.stringify(current_save)
	file.store_line(save_json)
	game_saved.emit()


func load_game() -> void:
	var file := FileAccess.open(SAVE_PATH + "save.sav", FileAccess.READ)
	var json := JSON.new()
	json.parse(file.get_line())
	var save_data: Dictionary = json.get_data() as Dictionary
	current_save = save_data

	GlobalLevelManager.load_new_level(current_save.scene_path, "", Vector2.ZERO)
	await GlobalLevelManager.level_load_started

	GlobalPlayerManager.set_player_position(Vector2(current_save.player.pos_x, current_save.player.pos_y))
	GlobalPlayerManager.set_player_health(current_save.player.hp, current_save.player.max_hp)

	await GlobalLevelManager.level_loaded

	game_loaded.emit()



func update_player_data() -> void:
	var player: Player = GlobalPlayerManager.player
	current_save.player.hp = player.hp
	current_save.player.max_hp = player.max_hp
	current_save.player.pos_x = player.global_position.x
	current_save.player.pos_y = player.global_position.y


func update_scene_path() -> void:
	var path: String = ""
	for c in get_tree().root.get_children():
		if c is Level:
			path = c.scene_file_path
	current_save.scene_path = path