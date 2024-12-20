extends Node

var settings: AppSettings
var error_notification: Control


func save():
	ResourceSaver.save(settings, "user://settings.tres")

func _init() -> void:
	
	# The first time loads the default settings
	if not ResourceLoader.exists("user://settings.tres"):
		settings = load("res://default_settings.tres")
	else:
		settings = load("user://settings.tres")
	
func _enter_tree() -> void:
	
	var textures = settings \
		.image_generator_params \
		.individual_generator_params \
		.populator_params.textures
	
	var texture_group: IndividualsTextureGroup = null
	
	for group in settings.individuals_texture_groups:
		if group.name == settings.default_texture_group_name:
			texture_group = group
			break
			
	if texture_group == null:
		push_error("Unable to find texture group named: %s" % settings.default_texture_group_name)
	
	# Loads default textures
	for default_texture in texture_group.textures:
		var renderer_texture = RendererTexture.load_from_texture(default_texture)
		textures.append(renderer_texture)
	
	# Loads default target texture
	var target_texture = RendererTexture.load_from_texture(settings.default_target_texture)
	
	if target_texture == null or not target_texture.is_valid():
		Notifier.notify_error("Unable to load default target texture")
		return
	
	settings.image_generator_params.individual_generator_params.target_texture = target_texture

func _exit_tree() -> void:

	# Clears previous textures
	var textures = settings \
			.image_generator_params \
			.individual_generator_params \
			.populator_params.textures
	
	textures.clear()

	save()
