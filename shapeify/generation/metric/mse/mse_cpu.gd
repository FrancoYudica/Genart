# CPU impelentation of MSE metric to compare results with compute shader version.
# This is just for testing
extends MSEMetric

var target_image: Image = null
var weight_image: Image = null
var _target_texture_2d_rd: Texture2DRD

func _init() -> void:
	metric_name = "Mean squared error"

func _target_texture_set():
	var target_texture_2d_rd = RenderingCommon.create_texture_from_rd_rid(target_texture.rd_rid)
	target_image = target_texture_2d_rd.get_image()

func _weight_texture_set():
	var weight_texture_2d_rd = RenderingCommon.create_texture_from_rd_rid(weight_texture.rd_rid)
	weight_image = weight_texture_2d_rd.get_image()


func _compute(source_texture: RendererTexture) -> float:
	var t = Time.get_ticks_msec()
	
	var color_attachment_texture = Renderer.get_attachment_texture(Renderer.FramebufferAttachment.COLOR)
	var color_attachment_data = Renderer.rd.texture_get_data(color_attachment_texture.rd_rid, 0)

	var source_image := ImageUtils.create_image_from_rgba8_buffer(
		color_attachment_texture.get_width(),
		color_attachment_texture.get_height(),
		color_attachment_data
	)
	
	# Term used to normalize the MSE
	var width = target_image.get_width()
	var height = target_image.get_height()
	
	# Calculates the sum of the squared differences
	var accumulated: float = 0.0
	var total_weight: float = 0.0
	for x in range(width):
		for y in range(height):
			var target_color = target_image.get_pixel(x, y)
			var source_color = source_image.get_pixel(x, y)
			var weight_color = weight_image.get_pixel(x, y)
			var diff = target_color - source_color
			var squared_diffs = diff.r * diff.r + diff.g * diff.g + diff.b * diff.b
			accumulated += squared_diffs * weight_color.r
			total_weight += weight_color.r
			
	# Calculates MSE
	var num_channels = 3.0
	var mse = accumulated / (total_weight * num_channels)
	return mse
