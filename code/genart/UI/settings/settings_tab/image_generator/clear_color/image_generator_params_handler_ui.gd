extends PanelContainer


@export var stop_condition: OptionButton
@export var clear_color: OptionButton
@export var weight_texture_generator_picker: WeightTextureGeneratorPicker

var _params : ImageGeneratorParams:
	get:
		return Globals.settings.image_generator_params

func _ready() -> void:
	
	# Stop condition option ----------------------------------------------------
	for option in StopCondition.Type.keys():
		stop_condition.add_item(option)
		
	stop_condition.item_selected.connect(
		func(index):
			_params.stop_condition = index as StopCondition.Type
	)

	# Clear color option -------------------------------------------------------
	for option in ClearColorStrategy.Type.keys():
		clear_color.add_item(option)
		
	clear_color.item_selected.connect(
		func(index):
			_params.clear_color_type = index as ClearColorStrategy.Type
	)

	Globals.image_generator_params_updated.connect(_update)
	_update()
	
func _update():
	stop_condition.select(_params.stop_condition)
	clear_color.select(_params.clear_color_type)
	weight_texture_generator_picker.set_params(_params.weight_texture_generator_params)
