extends KinematicBody2D

export var gravity := 400.0
export var speed := 200.0
export var flap_speed := 200.0
export var health := 100.0
export var death_fall_speed := 500.0

const IDLE = 0
const AIR = 1
const FLAP = 2

onready var anim := $AnimationPlayer

var velocity := Vector2()

var state = IDLE

func _ready():
	anim.connect("animation_finished", self, "_on_animation_finished")

func _physics_process(delta):
	var dir = InputUtils.get_input_dir()
	
	match state:
		IDLE:
			if dir.x:
				velocity.x = lerp(velocity.x, dir.x*speed, delta*2.0)
				anim.play("walk")
			else:
				velocity.x = lerp(velocity.x, 0.0, delta*4.0)
				anim.play("idle")
			if Input.is_action_just_pressed("ui_accept"):
				_change_state(FLAP)
			elif !is_on_floor():
				_change_state(AIR)
			

		AIR:
			
			if dir.x:
				velocity.x = lerp(velocity.x, dir.x*speed, delta*4.0)
			if Input.is_action_just_pressed("ui_accept"):
				_change_state(FLAP)
			elif is_on_floor():
				_change_state(IDLE)
		FLAP:
			if dir.x:
				velocity.x = dir.x*speed
			
	
	velocity.y += gravity * delta
	var vel_at_current_instant = velocity
	velocity = move_and_slide(velocity, Vector2.UP)
	if is_on_floor() and vel_at_current_instant.y > death_fall_speed:
		get_tree().reload_current_scene() 
	
	
func _change_state(new_state):
	state = new_state
	match state:
		IDLE:
			anim.play("idle")
		AIR:
			anim.play("air")
		FLAP:
			velocity.y -= flap_speed
			anim.play("flap")
func _on_animation_finished(anim_name):
	match state:
		IDLE:
			pass
		AIR:
			pass
		FLAP:
			_change_state(AIR)
