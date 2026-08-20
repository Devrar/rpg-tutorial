extends CanvasLayer

signal shown
signal hidden

var is_paused: bool = false

@onready var save_button: Button = $Control/HBoxContainer/SaveButton
@onready var load_button: Button = $Control/HBoxContainer/LoadButton
@onready var item_description: Label = $Control/ItemDescription

func _ready() -> void:
	hide_pause_menu()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if not is_paused:
			show_pause_menu()
		else:
			hide_pause_menu()
		get_viewport().set_input_as_handled()


func show_pause_menu() -> void:
	get_tree().paused = true
	visible = true
	is_paused = true
	shown.emit()


func hide_pause_menu() -> void:
	get_tree().paused = false
	visible = false
	is_paused = false
	hidden.emit()


func _on_save_button_pressed() -> void:
	if not is_paused:
		return
	GlobalSaveManager.save_game()
	hide_pause_menu()


func _on_load_button_pressed() -> void:
	if not is_paused:
		return
	GlobalSaveManager.load_game()
	await GlobalLevelManager.level_load_started
	hide_pause_menu()


func update_item_description(new_text: String) -> void:
	item_description.text = new_text