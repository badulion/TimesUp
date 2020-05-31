extends Camera2D


func _ready():
	pass

func shake():
	$AnimationPlayer.play("shake")
