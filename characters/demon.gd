extends CharacterBody2D

@export var speed = 100.0
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var anim_tree: AnimationTree = $AnimationTree

## BlendSpace2D: вверх (0,1), влево (-1,0), вправо (1,0), вниз (0,-1) — Y инвертирован относительно Input.get_vector.
var _last_blend := Vector2(0.0, -1.0)


func _ready() -> void:
	anim_tree.active = false
	anim_player.play("idle_down")


func _facing_from_input(v: Vector2) -> Vector2:
	if v == Vector2.ZERO:
		return _last_blend
	if absf(v.x) >= absf(v.y):
		return Vector2(1.0 if v.x > 0.0 else -1.0, 0.0)
	return Vector2(0.0, 1.0 if v.y < 0.0 else -1.0)


func _physics_process(_delta: float) -> void:
	var input_direction := Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	move_and_slide()

	if input_direction != Vector2.ZERO:
		_last_blend = _facing_from_input(input_direction)

	var moving := input_direction != Vector2.ZERO
	var prefix := "walk_" if moving else "idle_"
	var dir_suffix := _dir_suffix_from_blend(_last_blend)
	var anim_name := prefix + dir_suffix

	if anim_player.current_animation != anim_name:
		anim_player.play(anim_name)


func _dir_suffix_from_blend(blend: Vector2) -> String:
	var ax := absf(blend.x)
	var ay := absf(blend.y)
	if ax >= ay:
		return "right" if blend.x > 0.0 else "left"
	return "up" if blend.y > 0.0 else "down"
