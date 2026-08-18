class_name EnemyStateMachine
extends Node

var states: Array[EnemyState]
var previous_state: EnemyState
var current_state: EnemyState


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED


func _process(delta: float) -> void:
	change_state(current_state.process(delta))


func _physics_process(delta: float) -> void:
	change_state(current_state.physics_process(delta))


func initialize(enemy: Enemy) -> void:
	states = []

	for child in get_children():
		if child is EnemyState:
			states.append(child)
	
	for state in states:
		state.enemy = enemy
		state.state_machine = self
		state.init()
	
	if states.size() > 0:
		change_state(states[0])
		process_mode = Node.PROCESS_MODE_INHERIT


func change_state(new_state: EnemyState) -> void:
	if new_state == null or new_state == current_state:
		return
	
	if current_state:
		current_state.exit()
	
	previous_state = current_state
	current_state = new_state
	current_state.enter()