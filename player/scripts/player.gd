class_name Player
extends CharacterBody2D

var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var state_machine: PlayerStateMachine = $PlayerStateMachine


func _ready() -> void:
	state_machine.initialize(self)


func _process(_delta: float) -> void:
	direction = Vector2(
			Input.get_axis("left", "right"),
			Input.get_axis("up", "down"),
	).normalized()


func _physics_process(_delta: float) -> void:
	move_and_slide()


func update_animation(state: String) -> void:
	animation_player.play(state + "_" + anim_direction())


func set_direction() -> bool:
	var new_direction : Vector2 = cardinal_direction
	if direction == Vector2.ZERO:
		return false
	
	if direction.y == 0:
		new_direction = Vector2.RIGHT if direction.x > 0 else Vector2.LEFT
	elif direction.x == 0:
		new_direction = Vector2.DOWN if direction.y > 0 else Vector2.UP
	
	if new_direction == cardinal_direction:
		return false
	cardinal_direction = new_direction
	sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	return true


func anim_direction() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"

