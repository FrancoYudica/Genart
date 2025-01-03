extends TextureRect

@export var image_generation: Node

var _individual_generation_params: IndividualGeneratorParams:
	get:
		return Globals.settings.image_generator_params.individual_generator_params 

func _ready() -> void:
	_update_target_texture()

func _exit_tree() -> void:
	_free_texture()

func _on_image_loader_image_file_dropped(filepath: String) -> void:
	
	if not is_visible_in_tree():
		return
		
	var renderer_texture := RendererTexture.load_from_path(filepath)
	
	if renderer_texture == null or not renderer_texture.is_valid():
		Notifier.notify_error("Unable to load texture")
		return
	
	_individual_generation_params.target_texture = renderer_texture
	image_generation.refresh_target_texture()
	# Frees previous texture and updates
	_free_texture()
	_update_target_texture()
	
func _free_texture():
	var rd = RenderingServer.get_rendering_device()
	var texture_rd_rid = texture.texture_rd_rid
	texture.texture_rd_rid = RID()
	texture = null
	rd.free_rid(texture_rd_rid)


func _update_target_texture():
	
	var target_texture: RendererTexture = _individual_generation_params.target_texture
	if target_texture == null or not target_texture.is_valid():
		Notifier.notify_error("Unable to update_target_texture() if target texture is null")
		return
	
	# Creates texture for the first time
	texture = RenderingCommon.create_texture_from_rd_rid(target_texture.rd_rid)
