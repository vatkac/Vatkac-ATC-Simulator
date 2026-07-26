extends Node
class_name SaveManager

const SAVE_PATH = "user://savegame.sav"

static func save_game() -> void:
	var config := ConfigFile.new()
	
	config.set_value("System", "city", Settings.selected_city)
	config.set_value("System", "runway", Settings.runways_number)
	
	config.set_value("Player", "balance", UserData.current_balance)
	config.set_value("Player", "trust", UserData.current_trust)
	
	config.set_value("Game", "date", UserData.cur_date.to_unix())
	config.save(SAVE_PATH)

static func try_load_game() -> bool:
	var config := ConfigFile.new()
	if config.load(SAVE_PATH) != OK:
		return false
	
	Settings.selected_city = config.get_value("System", "city")
	Settings.runways_number = config.get_value("System", "runway")
	
	UserData.current_balance = config.get_value("Player", "balance")
	UserData.current_trust = config.get_value("Player", "trust")
	
	var date_unix = config.get_value("Game", "date")
	UserData.cur_date = GameDate.from_unix(date_unix)
	return true

static func remove_save_file() -> void:
	if not FileAccess.file_exists(SAVE_PATH): return
	DirAccess.remove_absolute(SAVE_PATH)
