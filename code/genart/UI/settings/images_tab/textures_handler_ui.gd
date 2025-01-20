extends PanelContainer

@export var texture_group_selector: Control
@export var textures_ui_container: Control

var image_item_packed = preload("res://UI/settings/images_tab/image_items/image_item.tscn")

## Maps image_item to RendererTexture
var _textures_map: Dictionary
var _populator_params: PopulatorParams:
	get:
		return Globals.settings.image_generator_params.individual_generator_params.populator_params

func _ready() -> void:
	texture_group_selector.selected_texture_group.connect(_load_texture_group)
	
	# Adds the default textures
	for renderer_texture in _populator_params.textures:
		
		if not renderer_texture.is_valid():
			continue
		
		var texture = RenderingCommon.create_texture_from_rd_rid(renderer_texture.rd_rid)
		var image_item = image_item_packed.instantiate()
		_add_image_item(image_item, renderer_texture)
		image_item.texture = texture
		

func _on_image_loader_image_file_dropped(filepath: String) -> void:
	
	if not is_visible_in_tree():
		return
	
	# Creates a renderer texture and adds to pupupator params
	var renderer_texture = RendererTexture.load_from_path(filepath)
	if renderer_texture == null:
		Notifier.notify_error("Dropped texture is null. File format not supported")
		return
	
	_populator_params.textures.append(renderer_texture)
	var image_item = image_item_packed.instantiate()
	_add_image_item(image_item, renderer_texture)
	image_item.filepath = filepath
	

func _add_image_item(image_item, renderer_texture):
	textures_ui_container.add_child(image_item)

	_textures_map[image_item] = renderer_texture

	# When removed, removes the texture from the params
	image_item.tree_exiting.connect(
		func():
			var texture: RendererTexture = _textures_map[image_item]
			_populator_params.textures.erase(texture)
	)
	

func _load_texture_group(group: IndividualsTextureGroup) -> void:
	
	for texture in group.textures:
		var renderer_texture := RendererTexture.load_from_texture(texture)
		_populator_params.textures.append(renderer_texture)
		var image_item = image_item_packed.instantiate()
		_add_image_item(image_item, renderer_texture)
		image_item.texture = texture


func _on_load_preset_button_pressed() -> void:
	texture_group_selector.visible = true
