tool
extends Node

const FIRST_MAP_NAME = "map-tutorial"
const SAVE_FILENAME = "user://save.k1"

var map_name = FIRST_MAP_NAME
var stats = {}

func _ready():
	load_game()

func reset():
	map_name = FIRST_MAP_NAME
	stats.clear()

func is_first_map():
	return map_name == FIRST_MAP_NAME

func write_stat(_map_name, best_time: float, apple_reached: bool):
	stats[_map_name] = {
		"best_time" : best_time,
		"apple_reached" : apple_reached
	}

func update_stat(elapsed_time: float, apple_reached: bool):
	var stat = stats[map_name]
	var best_time = elapsed_time \
			if stat.best_time == 0.0 or elapsed_time < stat.best_time else \
			stat.best_time
			
	var apple = stat.apple_reached or apple_reached
	write_stat(map_name, best_time, apple)
	save_game(map_name)

func current_stat():
	return stats[map_name]
	
func all_maps_full_completed():
	for key in stats.keys():
		if not stats[key].apple_reached:
			return false
	
	return true

func load_game():
	var f = File.new()
	
	if f.file_exists(SAVE_FILENAME):
		f.open(SAVE_FILENAME, File.READ)
		map_name = f.get_pascal_string()
		
		stats.clear()
		while not f.eof_reached():
			var key = f.get_pascal_string()
			var best_time = f.get_float()
			var apple_reached = f.get_8()
			
			if not key.empty():
				write_stat(key, best_time, apple_reached)
		
		f.close()

func save_game(map: String = ""):
	map_name = FIRST_MAP_NAME if map.empty() else map
	
	if not stats.has(map_name):
		write_stat(map_name, 0.0, false)
	
	var f = File.new()
	f.open(SAVE_FILENAME, File.WRITE)
	f.store_pascal_string(map_name)
	
	for key in stats.keys():
		var rec = stats[key]
		f.store_pascal_string(key)
		f.store_float(rec.best_time)
		f.store_8(rec.apple_reached)
	
	f.close()
