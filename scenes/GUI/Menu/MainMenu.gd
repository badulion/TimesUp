extends Control

func _ready():
	$BackgroundMusic.play(MenuSwitch.menu_music_location)
	$AnimationPlayer.play("background")
	$AnimationPlayer.seek(MenuSwitch.menu_background_location)


func _on_Start_pressed():
	$ButtonClick.play()
	MenuSwitch.menu_music_location = $BackgroundMusic.get_playback_position()
	MenuSwitch.menu_background_location = $AnimationPlayer.current_animation_position
	get_tree().change_scene("res://scenes/GUI/Menu/LevelSelection.tscn")


func _on_Continue_pressed():
	$ButtonClick.play()


func _on_Options_pressed():
	$ButtonClick.play()
	MenuSwitch.menu_music_location = $BackgroundMusic.get_playback_position()
	MenuSwitch.menu_background_location = $AnimationPlayer.current_animation_position
	var value = get_tree().change_scene("res://scenes/GUI/Menu/Options.tscn")


func _on_Quit_pressed():
	$ButtonClick.play()
	GameSaver.save_game()
	get_tree().quit()
