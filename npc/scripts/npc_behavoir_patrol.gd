@tool
extends NPCBehavior

const COLORS = [Color(1,0,0), Color(1,1,0), Color(0,1,0), Color(0,1,1), Color(0,0,1), Color(1,0,1)]

@export var walk_speed: float = 30.0

var patrol_locations: Array[PatrolLocation]
var current_location_index: int = 0
var target: PatrolLocation


func _ready() -> void:
	gather_patrol_locations()
	if Engine.is_editor_hint():
		child_entered_tree.connect(gather_patrol_locations)
		child_order_changed.connect(gather_patrol_locations)
		return
	super()
	if patrol_locations.size() == 0:
		process_mode = Node.PROCESS_MODE_DISABLED
		return
	target = patrol_locations[0]


func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	if npc.global_position.distance_to(target.target_position) < 1:
		start()


func gather_patrol_locations(_node: Node = null) -> void:
	patrol_locations = []
	for c in get_children():
		if c is PatrolLocation:
			patrol_locations.append(c)
	if Engine.is_editor_hint():
		if patrol_locations.size() > 0:
			for i in range(patrol_locations.size()):
				var p = patrol_locations[i] as PatrolLocation
				if not p.transform_changed.is_connected(gather_patrol_locations):
					p.transform_changed.connect(gather_patrol_locations)
				p.update_label(str(i))
				p.modulate = COLORS[i % COLORS.size()]

				var next_target: PatrolLocation = patrol_locations[(i+1) % patrol_locations.size()]
				p.update_line(next_target.position)


func start() -> void:
	if not npc.do_behavior or patrol_locations.size() < 2:
		return
	
	# idle phase
	npc.global_position = target.target_position
	npc.state = "idle"
	npc.velocity = Vector2.ZERO
	npc.update_animation()

	var wait_time: float = target.wait_time

	current_location_index = (current_location_index + 1) % patrol_locations.size()

	target = patrol_locations[current_location_index]

	await get_tree().create_timer(wait_time).timeout

	if not npc.do_behavior:
		return

	npc.state = "walk"
	var direction = global_position.direction_to(target.target_position)
	npc.direction = direction
	npc.velocity = walk_speed * direction
	npc.update_direction(target.target_position)
	npc.update_animation()

