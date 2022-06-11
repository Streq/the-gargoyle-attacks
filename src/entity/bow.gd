extends Node2D

const IDLE = 0
const SAW_THE_MF = 1
onready var cooldown := $cooldown
export var angle_degs := 45.0
export var ARROW : PackedScene


# Called when the node enters the scene tree for the first time.
func _ready():
	yield(owner,"ready")
	rotation = Vector2(owner.walk_dir,0.0).angle()


func can_see_gargoyle(target):
	if is_instance_valid(target):
		var angle = rad2deg(get_angle_to(target.global_position))
		if abs(angle) < angle_degs/2:
			var space_state = get_world_2d().direct_space_state
			var exceptions = Group.get_all("person")
			var result = space_state.intersect_ray(global_position, target.global_position, exceptions)
			return (result.has("collider") and result.collider == target)

func _physics_process(delta):
	var target = Group.get_one("player")
	
	if owner.state != Person.GRABBED and can_see_gargoyle(target):
		global_rotation += get_angle_to(target.global_position)
		if cooldown.is_stopped():
			cooldown.start()
			var arrow = ARROW.instance()
			get_tree().current_scene.add_child(arrow)
			arrow.global_position = self.global_position
			arrow.global_rotation = self.global_rotation


