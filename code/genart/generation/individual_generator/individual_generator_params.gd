class_name IndividualGeneratorParams extends Resource

@export var populator_params := PopulatorParams.new():
	set(value):
		if value != populator_params:
			populator_params = value
			emit_changed()
			
@export var target_texture: RendererTexture:
	set(value):
		if value != target_texture:
			target_texture = value
			emit_changed()

@export var color_sampler := ColorSamplerStrategy.Type.MASKED:
	set(value):
		if value != color_sampler:
			color_sampler = value
			emit_changed()

@export var keep_aspect_ratio: bool = false:
	set(value):
		if value != keep_aspect_ratio:
			keep_aspect_ratio = value
			emit_changed()

@export var clamp_position_in_canvas: bool = true:
	set(value):
		if value != clamp_position_in_canvas:
			clamp_position_in_canvas = value
			emit_changed()

@export var fixed_rotation: bool = true:
	set(value):
		if value != fixed_rotation:
			fixed_rotation = value
			emit_changed()
			
@export var fixed_rotation_angle: float = 0.0:
	set(value):
		if value != fixed_rotation_angle:
			fixed_rotation_angle = value
			emit_changed()

@export var fixed_size: bool = false:
	set(value):
		if value != fixed_size:
			fixed_size = value
			emit_changed()

@export var fixed_size_width_ratio: float = 0.1:
	set(value):
		if value != fixed_size_width_ratio:
			fixed_size_width_ratio = value
			emit_changed()

@export var best_of_random_params := BestOfRandomIndividualGeneratorParams.new()
@export var genetic_params := GeneticIndividualGeneratorParams.new()
@export var hill_climbing_params := HillClimbingIndividualGeneratorParams.new()

func to_dict() -> Dictionary:
	return {
		"target_texture_width" : target_texture.get_width(),
		"target_texture_height" : target_texture.get_height(),
		"color_sampler": ColorSamplerStrategy.Type.keys()[color_sampler],
		"best_of_random_params" : best_of_random_params.to_dict(),
		"genetic_params" : genetic_params.to_dict()
	}

func setup_changed_signals() -> void:
	best_of_random_params.setup_changed_signals()
	genetic_params.setup_changed_signals()
	
	best_of_random_params.changed.connect(emit_changed)
	genetic_params.changed.connect(emit_changed)
	hill_climbing_params.changed.connect(emit_changed)
