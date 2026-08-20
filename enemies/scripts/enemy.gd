class_name Enemy
extends CharacterBody2D

signal direction_changed(new_direction: Vector2)
signal enemy_damaged(hurtbox: Hurtbox)
signal enemy_destroyed(hurtbox: Hurtbox)

@export var hp: int = 3

var cardinal_direction: Vector2 = Vector2.DOWN
var direction: Vector2 = Vector2.ZERO
var player: Player
var invulnerable: bool = false

const DIR_4 = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var state_machine: EnemyStateMachine = $EnemyStateMachine
@onready var hitbox: Hitbox = $Hitbox
@onready var hurtbox: Hurtbox = $Hurtbox


func _ready() -> void:
	state_machine.initialize(self)
	player = GlobalPlayerManager.player
	hitbox.damage_taken.connect(_take_damage)


func _physics_process(_delta: float) -> void:
	move_and_slide()


func set_direction(new_direction: Vector2) -> bool:
	direction = new_direction
	if direction == Vector2.ZERO:
		return false
	
	var direction_id: int = round((direction + cardinal_direction * 0.1).angle() / TAU * DIR_4.size())
	var new_cardinal_direction = DIR_4[direction_id]
	
	if new_cardinal_direction == cardinal_direction:
		return false
	
	cardinal_direction = new_cardinal_direction
	direction_changed.emit(new_cardinal_direction)
	sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1

	return true


func update_animation(state: String) -> void:
	animation_player.play(state + "_" + anim_direction())


func anim_direction() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"


func _take_damage(hurtbox: Hurtbox) -> void:
	if invulnerable:
		return
	hp -= hurtbox.damage
	if hp <= 0:
		enemy_destroyed.emit(hurtbox)
	else:
		enemy_damaged.emit(hurtbox)