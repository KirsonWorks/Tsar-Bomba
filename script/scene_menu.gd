extends "res://script/scene_base.gd"

func _ready():
	set_options()
	$ui/menu_main/item_continue.visible = not Global.is_first_map()
	
func set_options():
	$ui/menu_options/slot_resolution.data = Config.get_resolution_list()
	$ui/menu_options/slot_resolution.data_index = Config.resolution
	$ui/menu_options/slot_fullscreen.data_index = int(Config.fullscreen)
	$ui/menu_options/slot_sound.value = Config.sounds_level
	$ui/menu_options/slot_music.value = Config.music_level
	
func change_menu(next_menu):
	next_menu.show()

func _on_item_new_game_action():
	Global.reset()
	change_scene("res://scene/scene_game.tscn")

func _on_item_continue_action():
	change_scene("res://scene/scene_game.tscn")

func _on_item_options_action():
	change_menu($ui/menu_options)

func _on_item_credits_action():
	change_menu($ui/menu_credits)

func _on_item_quit_action():
	get_tree().quit()

func _on_item_apply_action():
	Config.resolution = $ui/menu_options/slot_resolution.data_index
	Config.fullscreen = bool($ui/menu_options/slot_fullscreen.data_index)
	Config.sounds_level = $ui/menu_options/slot_sound.as_int
	Config.music_level = $ui/menu_options/slot_music.as_int
	Config.save_to_file()
	
	$ui/menu_options.hide()
