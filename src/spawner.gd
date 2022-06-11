extends Position2D

export var BOWMAN : PackedScene
export var PERSON : PackedScene
export var initial_time = 3.0
export var limit_time = 2.0
export var dir = 1.0

onready var timer = $Timer

func spawn():
	var instance
	var odds = rand_range(0.0, 100.0)
	print_debug("spawn with odds:",odds)
	if odds > 90.0:
		instance = BOWMAN.instance()
	elif odds > 35.0:
		instance = PERSON.instance()
	else:
		return
	instance.walk_dir = dir
	add_child(instance)

func _on_Timer_timeout():
	spawn()
	initial_time = max(limit_time, initial_time*0.95)
	timer.wait_time = initial_time
	timer.start()
