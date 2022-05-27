extends Node
class_name StateMachine
signal state_changed(state)

export (String) var start_state

var current: State = null
var states:= {}
export var autostart := false


func _ready():
	if autostart:
		initialize()
	else:
		pause(true)
	

func initialize():
	for state in get_children():
		states[state.name] = state
		state.connect("finish", self, "_change_state")
	current = states[start_state]
	current.enter(null)
	pause(false)
	
func _process(delta: float):
	current.update(delta)

func _physics_process(delta: float):
	current.physics_update(delta)

func physics_update(delta: float):
	current.physics_update(delta)

func update(delta: float):
	current.update(delta)

func _input(event: InputEvent):
	current._handle_input(event)

func _change_state(state_name: String, params):
	current.exit()
	current = states[state_name]
	current.enter(params)
	emit_signal("state_changed", state_name)

func pause(paused: bool):
	var val = !paused
	set_process(val)
	set_process_input(val)
	set_process_internal(val)
	set_process_unhandled_input(val)
	set_process_unhandled_key_input(val)
	set_physics_process(val)
	set_physics_process_internal(val)
