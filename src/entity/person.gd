extends KinematicBody2D
class_name Person

export var gravity := 400.0
export var speed := 200.0
export var death_fall_speed := 500.0
export (float, -1.0, 1.0, 2.0) var walk_dir = 1.0

const IDLE = 0
const AIR = 1
const WALK = 2
const GRABBED = 3

onready var anim := $AnimationPlayer

var velocity := Vector2()

var state = WALK

func _ready():
	anim.connect("animation_finished", self, "_on_animation_finished")
	_change_state(state)

func _physics_process(delta):
	match state:
		WALK:
			if !is_on_floor():
				_change_state(AIR)
			elif walk_dir:
				velocity.x = walk_dir*speed
				anim.play("walk")

		AIR:
			if is_on_floor():
				_change_state(WALK)
		
		GRABBED:
			velocity = Vector2()
			
	match state:
		GRABBED:
			pass
		_:
			velocity.y += gravity * delta
			var vel_at_current_instant = velocity
			velocity = move_and_slide(velocity, Vector2.UP)
			if is_on_floor() and vel_at_current_instant.y > death_fall_speed:
				queue_free()
	
	
func _change_state(new_state):
	state = new_state
	match state:
		IDLE:
			anim.play("idle")
		WALK:
			anim.play("walk")
		AIR:
			anim.play("air")
		GRABBED:
			anim.play("air")
func _on_animation_finished(anim_name):
	match state:
		IDLE:
			pass
		AIR:
			pass

func on_grab():
	_change_state(GRABBED)
func on_let_go():
	pass
