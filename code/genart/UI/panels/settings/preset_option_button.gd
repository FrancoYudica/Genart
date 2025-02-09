extends OptionButton

func _ready() -> void:
	for key_name in ImageGeneratorParams.Type.keys():
		add_item(key_name)
	
	set_item_disabled(0, true)
	
	item_selected.connect(
		func(index):
			Globals.image_generator_params_set_preset(
				index as ImageGeneratorParams.Type)
	)
	
	Globals.generation_started.connect(
		func():
			disabled = true
	)

	Globals.generation_finished.connect(
		func():
			disabled = false
	)

	_update()

func _process(delta: float) -> void:
	_update()

func _update():
	selected = Globals.settings.image_generator_params.type
