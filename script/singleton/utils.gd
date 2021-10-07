tool
extends Node

const PATH_FLAG = 1
const FILENAME_FLAG = 2
const EXTENSION_FLAG = 4
const ABSOLUTE = PATH_FLAG | FILENAME_FLAG | EXTENSION_FLAG

func _ready():
	pass
	
func scan_dir(path: String, flags):
	var list = []
	var dir = Directory.new()
	
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var filename = dir.get_next()
		
		while filename != "":
			if not dir.current_is_dir():
				var result = ""
				
				if flags & PATH_FLAG > 0:
					result = path
				
				if flags & FILENAME_FLAG > 0:
					result += filename
					
				if flags & EXTENSION_FLAG == 0:
					var ext = filename.get_extension()
					result = result.replace("." + ext, "")
				
				list.append(result)
			
			filename = dir.get_next()
	
	return list
