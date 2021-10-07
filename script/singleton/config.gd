tool
extends Node

const CONF_FILE_NAME = "user://conf.k1"
const DEFAULT_SOUNDS = 100
const DEFAULT_MUSIC = 100
const DEFAULT_RESOLUTION = 2
const DEFAULT_FULLSCREEN = false

const BUS_SOUNDS = 1
const BUS_MUSIC = 2

var sounds_level: int = DEFAULT_SOUNDS
var music_level: int = DEFAULT_MUSIC
var resolution: int = DEFAULT_RESOLUTION
var fullscreen: bool = DEFAULT_FULLSCREEN

const resolution_list = [Vector2(800, 600),
						 Vector2(960, 720),
						 Vector2(1024, 768),
						 Vector2(1280, 720),
						 Vector2(1280, 800),
						 Vector2(1280, 1024),
						 Vector2(1360, 768),
						 Vector2(1366, 768),
						 Vector2(1440, 900),
						 Vector2(1600, 900),
						 Vector2(1680, 1050),
						 Vector2(1920, 1080)]

func _init():
	load_from_file()

func set_sounds_volume(level):
	AudioServer.set_bus_volume_db(BUS_SOUNDS, linear2db(level / 100.0))

func set_music_volume(level):
	AudioServer.set_bus_volume_db(BUS_MUSIC, linear2db(level / 100.0))

func get_resolution():
	var ws = OS.window_size
	var res = resolution_list[resolution]
	
	if fullscreen:
		if res.x > ws.x or res.y > ws.y:
			return ws
		else:
			return res
	else:
		return ws

func get_resolution_list():
	var list = []
	
	for res in resolution_list:
		var s = "%dX%d" % [int(res.x), int(res.y)]
		list.append(s)
		
	return list

func save_to_file():
	var f = File.new()
	
	f.open(CONF_FILE_NAME, File.WRITE)
	f.store_32(sounds_level)
	f.store_32(music_level)
	f.store_32(resolution)
	f.store_8(fullscreen)
	f.close()
	
	apply()
	
func load_from_file():
	var f = File.new()
	
	if not f.file_exists(CONF_FILE_NAME):
		return
	
	f.open(CONF_FILE_NAME, File.READ)
	sounds_level = f.get_32()
	music_level = f.get_32()
	resolution = f.get_32()
	fullscreen = bool(f.get_8())
	f.close()
	
	apply()

func apply():
	if Engine.editor_hint:
		return
		
	set_sounds_volume(sounds_level)
	set_music_volume(music_level)
	
	if OS.window_fullscreen != fullscreen:
		OS.window_fullscreen = fullscreen
	
	if OS.window_size != resolution_list[resolution]:
		OS.window_size = resolution_list[resolution]
		
		if not fullscreen:
			OS.center_window()
	
func reset_to_default():
	sounds_level = DEFAULT_SOUNDS
	music_level = DEFAULT_MUSIC
	resolution = DEFAULT_RESOLUTION
	fullscreen = DEFAULT_FULLSCREEN

	save_to_file()
