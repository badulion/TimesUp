extends Node

const MAX_TIME_FUEL = 20
var current_time_fuel = MAX_TIME_FUEL

var stop_time_parameter = 0.01
var slow_time_parameter = 0.3
var normal_time_parameter = 1

var current_time_parameter = normal_time_parameter


func _ready():
	normal_time()
	
func _process(delta):
	_get_input()
	_process_time_fuel(delta)
	get_tree().call_group("HUD", "set_max_time_fuel", MAX_TIME_FUEL)
	

	
func _get_input():
	if Input.is_action_just_pressed("slow_time") and current_time_fuel > 0:
		stop_time()
		current_time_parameter = stop_time_parameter
	elif Input.is_action_just_released("slow_time"):
		normal_time()
		current_time_parameter = normal_time_parameter
	elif current_time_fuel == 0:
		normal_time()
		current_time_parameter = normal_time_parameter
		
		
func _process_time_fuel(delta):
	current_time_fuel = clamp(current_time_fuel-((delta/Engine.time_scale)*(1-Engine.time_scale)), 0, MAX_TIME_FUEL)
	get_tree().call_group("HUD", "update_time_fuel", current_time_fuel)
	
func stop_time():
	Engine.time_scale = stop_time_parameter
	
func slow_time():
	Engine.time_scale = slow_time_parameter
	
func normal_time():
	Engine.time_scale = normal_time_parameter
	
func default_time():
	Engine.time_scale = current_time_parameter

func speedup(time=.1):
	$SpeedupTimer.stop()
	$SpeedupTimer.start(time)
	slow_time()

func _on_SpeedupTimer_timeout():
	default_time()

func add_fuel(amount = MAX_TIME_FUEL/5):
	current_time_fuel = clamp(current_time_fuel+amount, 0, MAX_TIME_FUEL)
	
func reset_fuel():
	current_time_fuel = MAX_TIME_FUEL
