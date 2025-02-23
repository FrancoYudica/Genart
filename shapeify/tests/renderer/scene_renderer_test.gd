extends Node

@onready var viewport_control := $ViewportControl
@onready var output_texture := $"../CanvasLayer/RendererOutputTextureRect"

var clear_color := Color.BEIGE

func _ready() -> void:
	Renderer.render_scale = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	var t0 = Time.get_ticks_usec()

	Renderer.begin_frame(viewport_control.size)
	Renderer.render_clear(clear_color)
	var i = 0
	for texture_rect: TextureRect in viewport_control.get_children():
		Renderer.render_sprite(
			texture_rect.position,
			texture_rect.size,
			texture_rect.rotation + Time.get_ticks_msec() / 1000.0,
			texture_rect.modulate,
			texture_rect.texture as RendererTexture,
			(i + 1.0) / viewport_control.get_child_count()
		)
		i += 1
	Renderer.end_frame()
	
	var dt_ms = (Time.get_ticks_usec() - t0) / 1000.0
	print(dt_ms)
	
	output_texture.update_texture()
