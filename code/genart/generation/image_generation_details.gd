## Information used to replicate the generated image.
class_name ImageGenerationDetails extends RefCounted

## Individuals in order of generation
var individuals: Array[Individual] = []

## Initial color of the generated texture
var clear_color := Color.BLACK

## Size of the generated texture
var viewport_size: Vector2i

var time_taken_ms: int

var executed_count: int

var generated_texture: RendererTexture
