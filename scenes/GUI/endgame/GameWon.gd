extends Control


func _ready():
	pass


func _on_BackButton_pressed():
	var value = get_tree().change_scene("res://scenes/GUI/Menu/MainMenu.tscn")

func _on_ForwardButton_pressed():
	var value = get_tree().change_scene("res://scenes/levels/Level%d.tscn" % (GameSaver.current_level+1))
