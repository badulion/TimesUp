extends Node

var current_level

const SAVE_GAME_PATH = "data.sav"

#complete save data:
var save_data = {
	'max_level': 1,
}

func _ready():
	var save_file = File.new()
	if save_file.file_exists(SAVE_GAME_PATH):
		save_data = _read_json(SAVE_GAME_PATH)
	else:
		_write_json(SAVE_GAME_PATH, save_data)

func _read_json(filename):
	var file = File.new()
	file.open(filename, File.READ)
	var file_as_text = file.get_as_text()
	var data = parse_json(file_as_text)
	file.close()
	return data

func _write_json(filename, data):
	var file = File.new()
	file.open(filename, File.WRITE)
	file.store_line(to_json(data))
	file.close()
	return data
	
func save_game():
	_write_json(SAVE_GAME_PATH, save_data)
