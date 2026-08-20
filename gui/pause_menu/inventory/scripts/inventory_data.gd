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
		s.changed.connect(slot_changed)


func slot_changed() -> void:
	for s in slots:
		if s:
			if s.quantity < 1:
				s.changed.disconnect(slot_changed)
				var index = slots.find(s)
				slots[index] = null
				changed.emit()
