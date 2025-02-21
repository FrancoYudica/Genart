class_name FrameSaver extends RefCounted

enum Type
{
	PNG,
	JPG,
	WEBP,
	JSON_FORMAT
}

## True if notifications are silenced
var silent: bool = false

func save(
	filepath: String,
	shapes: Array[Shape],
	clear_color: Color,
	viewport_size: Vector2i) -> bool:
	return false

func get_extension() -> String:
	return ""

static func factory_create(type: Type) -> FrameSaver:
	match type:
		Type.PNG:
			return load("res://generation/frame_saver/strategies/png_frame_save_strategy.gd").new()
		Type.JPG:
			return load("res://generation/frame_saver/strategies/jpg_frame_save_strategy.gd").new()
		Type.WEBP:
			return load("res://generation/frame_saver/strategies/webp_frame_save_strategy.gd").new()
		Type.JSON_FORMAT:
			return load("res://generation/frame_saver/strategies/json_frame_save_strategy.gd").new()
		_:
			return null
