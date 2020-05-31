extends Control


func _ready():
	$BackgroundMusic.play(MenuSwitch.menu_music_location)
	$AnimationPlayer.play("background")
	$AnimationPlayer.seek(MenuSwitch.menu_background_location)
	show_available_levels()


func _on_Back_pressed():
	MenuSwitch.menu_music_location = $BackgroundMusic.get_playback_position()
	MenuSwitch.menu_background_location = $AnimationPlayer.current_animation_position
	var value = get_tree().change_scene("res://scenes/GUI/Menu/MainMenu.tscn")

func show_available_levels():
	for level in $CenterContainer/VBoxContainer/GridContainer.get_children():
		if int(level.name[-1]) <= GameSaver.save_data['current_level']:
			level.set("disabled", false)
		else:
			level.set("disabled", true)


func _on_Level1_pressed():
	var value = get_tree().change_scene("res://scenes/levels/Level1.tscn")
