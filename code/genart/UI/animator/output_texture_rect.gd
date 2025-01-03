extends TextureRect

@export var animator: Node
@export var white_texture: RendererTextureLoad
var _output_rd_texture

func _ready() -> void:
	animator.individuals_animated.connect(_animated_individuals)
	
func _exit_tree() -> void:
	_free_texture()

func _process(delta: float) -> void:
	if not is_visible_in_tree():
		_free_texture()
		

func _animated_individuals(individuals: Array[Individual]):
	
	_render_individuals(individuals)
	_update_texture()


func _render_individuals(individuals):
	
	var viewport_size = animator.image_generation_details.viewport_size
	Renderer.begin_frame(viewport_size)
	
	# Renders background
	Renderer.render_sprite(
		viewport_size * 0.5,
		viewport_size,
		0.0,
		animator.image_generation_details.clear_color,
		white_texture,
		0.0)
	
	# Renders individuals
	for individual in individuals:
		Renderer.render_sprite(
			individual.position,
			individual.size,
			individual.rotation,
			individual.tint,
			individual.texture,
			1.0)
	Renderer.end_frame()
	

func _create_texture():
	_free_texture()

	var attachment: RendererTexture = Renderer.get_attachment_texture(Renderer.FramebufferAttachment.COLOR)
	var texture_rd: Texture2DRD = RenderingCommon.create_texture_from_rd_rid(attachment.rd_rid)
	
	texture = texture_rd


func _update_texture():
	
	if texture == null:
		_create_texture()

	var color_attachment = Renderer.get_attachment_texture(Renderer.FramebufferAttachment.COLOR)
	RenderingCommon.texture_copy(
		color_attachment.rd_rid,
		texture.texture_rd_rid,
		Renderer.rd,
		RenderingServer.get_rendering_device()
	)

func _free_texture():
	
	if texture == null:
		return
	
	var rd = RenderingServer.get_rendering_device()
	var texture_rd_rid = texture.texture_rd_rid
	texture.texture_rd_rid = RID()
	texture = null
	rd.free_rid(texture_rd_rid)
