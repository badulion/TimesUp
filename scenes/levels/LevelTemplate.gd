extends Node2D

var total_enemies_count = 0
var current_enemies_count = 0

func _ready():
	total_enemies_count = $Enemies.get_child_count()
	current_enemies_count = total_enemies_count
	get_tree().call_group("HUD", "update_enemies", current_enemies_count, total_enemies_count)
	_connect_enemy_signals()
	GameSaver.current_level = int(name[-1])
	TimeControl.reset_fuel()
	
func _input(event):
	if event.is_action_pressed("menu"):
		var value = get_tree().change_scene("res://scenes/GUI/Menu/MainMenu.tscn")

func _connect_enemy_signals():
	for child in $Enemies.get_children():
		child.connect("die", self, "_on_Enemy_die")

func _on_Player_player_die():
	var value = get_tree().change_scene("res://scenes/GUI/endgame/GameLost.tscn")

func _on_Enemy_die():
	current_enemies_count -= 1
	get_tree().call_group("HUD", "update_enemies", current_enemies_count, total_enemies_count)
	if current_enemies_count == 0:
		_win_level()

func _win_level():
	var value = get_tree().change_scene("res://scenes/GUI/endgame/GameWon.tscn")
	GameSaver.save_data['max_level'] = max(GameSaver.save_data['max_level'], GameSaver.current_level+1)
