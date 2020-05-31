extends Control

func _ready():
	$BackgroundMusic.play(MenuSwitch.menu_music_location)
	$AnimationPlayer.play("background")
	$AnimationPlayer.seek(MenuSwitch.menu_background_location)


func _on_Audio_pressed():
	$ButtonClick.play()

func _on_Video_pressed():
	$ButtonClick.play()


func _on_Controls_pressed():
	$ButtonClick.play()

func _on_Back_pressed():
	MenuSwitch.menu_music_location = $BackgroundMusic.get_playback_position()
	MenuSwitch.menu_background_location = $AnimationPlayer.current_animation_position
	var value = get_tree().change_scene("res://scenes/GUI/Menu/MainMenu.tscn")
