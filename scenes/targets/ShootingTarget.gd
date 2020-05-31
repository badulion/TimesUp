extends Area2D




# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func hurt():
	$AudioStreamPlayer.play()
	visible = false
	set_deferred("monitoring", false)
	TimeControl.add_fuel()
	$DeleteTimer.start()
	




func _on_DeleteTimer_timeout():
	visible = true
	set_deferred("monitoring", true)
