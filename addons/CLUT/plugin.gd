@tool
extends EditorPlugin

const PNG_EXTENSION: String = ".png"

var base_suffix: String = ".base"
var source_suffix: String = ".source"
var map_suffix: String = ".map"

var editor_settings: EditorSettings = self.get_editor_interface().get_editor_settings()
var editor_filesystem: EditorFileSystem = self.get_editor_interface().get_resource_filesystem()

func _enter_tree() -> void:
	editor_filesystem.resources_reimported.connect(_on_resource_imported)
	_set_settings()

func _set_settings():
	if editor_settings.has_setting("filesystem/CLUT/base_suffix"): 
		base_suffix = editor_settings.get_setting("filesystem/CLUT/base_suffix")
	else: 
		editor_settings.set_setting("filesystem/CLUT/base_suffix", base_suffix)

	if editor_settings.has_setting("filesystem/CLUT/source_suffix"): 
		source_suffix = editor_settings.get_setting("filesystem/CLUT/source_suffix")
	else: 
		editor_settings.set_setting("filesystem/CLUT/source_suffix", source_suffix)

	if editor_settings.has_setting("filesystem/CLUT/map_suffix"): 
		map_suffix = editor_settings.get_setting("filesystem/CLUT/map_suffix")
	else: 
		editor_settings.set_setting("filesystem/CLUT/map_suffix", map_suffix)


func _on_resource_imported(resources: PackedStringArray) -> void:
	_set_settings()
	
	var source_path: String = ""
	var map_path: String = ""
	
	for res in resources:
		var res_dir: String = res.get_base_dir()
		if res.contains(base_suffix): continue
		for file in DirAccess.get_files_at(res_dir):
			if file.contains(".import"): continue
			if file.contains(map_suffix):
				map_path = "%s/%s" % [res_dir, file]
			if file.contains(source_suffix):
				source_path = "%s/%s" % [res_dir, file]
				
			if not source_path.is_empty() and not map_path.is_empty():
				var base: Image = _generate_base_image(source_path, map_path)
				var base_name: String = "%s%s%s" % [file.right(file.length() - file.rfind("/")-1).split(".")[0], base_suffix, PNG_EXTENSION]
				var save_path: String = "%s/%s" % [res_dir, base_name]
				
				base.save_png(save_path)
				editor_filesystem.scan()
				return print("Base CLUT: %s; created at: %s" % [base_name, save_path])


func _generate_base_image(source_path: String, map_path: String) -> Image:
	var source: Image = ResourceLoader.load(source_path, "Texture2D", ResourceLoader.CACHE_MODE_REPLACE).get_image()
	var map: Image = ResourceLoader.load(map_path, "Texture2D", ResourceLoader.CACHE_MODE_REPLACE).get_image()
	var base: Image = Image.create(source.get_width(), source.get_height(), false, Image.FORMAT_RGBA8)
	
	for y in source.get_height():
		for x in source.get_width():
			var color: Color = source.get_pixel(x, y)
			var uv: Vector2i = _find_color_on_map(map, color)
			if uv != Vector2i(-1, -1):
				base.set_pixel(x, y, Color8(uv.x, uv.y, 0, 255))
	return base

func _find_color_on_map(map: Image, color: Color) -> Vector2i:
	var uv: Vector2i = Vector2i(-1,-1)
	if not color.a:
		return uv
	for y in map.get_height():
		for x in map.get_width():
			if color == map.get_pixel(x, y):
				uv = Vector2i(x, y)
				return uv
	return uv
