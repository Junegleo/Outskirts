extends CharacterBody2D

@export var speed = 100.0
@onready var anim_tree = $AnimationTree

## BlendSpace2D: up (0,1), left (-1,0), right (1,0), down (0,-1) — Y инвертирован относительно Input.get_vector.
var _last_blend := Vector2(0.0, -1.0)

func _ready() -> void:
	anim_tree.active = true

func _physics_process(_delta: float) -> void:
	var input_direction := Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	move_and_slide()

	if input_direction != Vector2.ZERO:
		_last_blend = Vector2(input_direction.x, -input_direction.y)
	anim_tree.set("parameters/blend_position", _last_blend)
