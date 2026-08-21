class_name InventoryData
extends Resource

@export var slots: Array[SlotData]


func _init() -> void:
	connect_slots()


func add_item(item: ItemData, count: int = 1) -> bool:
	for slot in slots:
		if slot != null:
			if slot.item_data == item:
				slot.quantity += count
				return true

	for i in slots.size():
		if slots[i] == null:
			var new_slot = SlotData.new()
			new_slot.item_data = item
			new_slot.quantity = count
			new_slot.changed.connect(slot_changed)
			slots[i] = new_slot
			return true

	print("[!] Inventory full")
	return false


func connect_slots() -> void:
	for s in slots:
		if s:
			s.changed.connect(slot_changed)


func slot_changed() -> void:
	for s in slots:
		if s:
			if s.quantity < 1:
				s.changed.disconnect(slot_changed)
				var index = slots.find(s)
				slots[index] = null
				changed.emit()


func get_save_data() -> Array:
	var item_save: Array = []
	for i in slots.size():
		item_save.append(item_to_save(slots[i]))
	return item_save


func item_to_save(slot: SlotData) -> Dictionary:
	var result = { item_path = "", quantity = 0 }
	if slot != null:
		result.quantity = slot.quantity
		result.item_path = slot.item_data.resource_path
	return result


func parse_save_data(save_data: Array) -> void:
	var array_size = slots.size()
	slots.clear()
	slots.resize(array_size)
	for i in save_data.size():
		slots[i] = item_from_save(save_data[i])
	connect_slots()


func item_from_save(save_object: Dictionary) -> SlotData:
	if save_object.item_path == "":
		return null
	var new_slot = SlotData.new()
	new_slot.item_data = load(save_object.item_path)
	new_slot.quantity = save_object.quantity
	return new_slot


func use_item(item: ItemData, count: int = 1) -> bool:
	for s in slots:
		if s:
			if s.item_data == item and s.quantity >= count:
				s.quantity -= count
				return true
	return false